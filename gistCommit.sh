#!/bin/bash

echo "what is the ending commit"
endCommitDef="49c52dbbc9b1adfa527ced3b69b5b28575fe32af";
read endCommitIn;
endCommit="${endCommitIn:-${endCommitDef}}";

echo "what is the starting commit (blank means just that commit)"
startCommitDef="${endCommit}~1";
read startCommitIn;
startCommit="${startCommitIn:-${startCommitDef}}";

# determine which files have changed
linesChanged=`git diff "${startCommit}..${endCommit}" --name-only`

echo "starting to upload commits[${startCommit}:${endCommit}]"

# if we should only list the changes first
# then echo out those changes and stop the program.
if [[ "${1}" == "-test" || "${1}" == "--test" ]]; then
	echo "the following are the files that would be uploaded to the gist"
	echo "${linesChanged}"
	return;
fi

# create a description using the commit range
gistDesc="${startCommit}..${endCommit}"

unset gistURL;

#loop through each file to be changed and load the initial file to the gist.
while read -r line; do
	if [[ "${line}" == *".map"* ]]; then
		echo -n ""
		#echo "--ignoring map files"
	elif [[ -z "${gistURL}" ]]; then
		#echo "gistUrl not set"
		#git show "${startCommit}:${line}"
		gistURL=`git show "${startCommit}:${line}" | gist -p -d "${gistDesc}" -f "${line}"`
		echo "[${line}] uploaded to gist: ${gistURL}"
	else
		#echo "gistURL[${gistURL}]"
		gitURL2=`git show "${startCommit}:${line}" | gist -u "${gistURL}" -f "${line}"`
		echo "[${line}] uploaded to gist: ${gitURL2}"
	fi
done <<< "${linesChanged}"

#second pass to include the latest version of the file
while read -r line; do
	#echo "...${line}..."
	
	if [[ "${line}" == *".map"* ]]; then
		echo -n ""
		#echo "--ignoring map files"
	else
		gitURL2=`git show "${endCommit}:${line}" | gist -u "${gistURL}" -f "${line}"`
		echo "[${line}] uploaded to gist: ${gitURL2}"
	fi
done <<< "${linesChanged}"

echo "created gist:${gistURL}"