#!/bin/bash

arg1="${1}"
arg2="${2}"
arg3="${3}"
arg4="${4}"

if [[ -z "${arg1}" ]]; then
	echo "Please provite a git commit to create the gist from."
	echo ""
	echo "gistCommit can be run in two ways:"
	echo ". gistCommit [Commit SHA]"
	echo "or"
	echo ". gistCommit [From Commit SHA] [To Commit SHA]"
	echo ""
	echo "- To just see what changes would be sent, run -"
	echo ". gistCommit --test"
	echo ""
	echo "(protip, use ~1 to return the commit before"
	echo "such as 287e240f6e8362f2ba16e7ba4d359660e3cf15e4~1)"
	echo ""
	
	exit;
fi

# use replacements to allow for unsetting flags.
unset isTest;
if [[ "${arg1}" == "--test" ]]; then
	isTest="true"
	unset arg1;
elif [[ "${arg2}" == "--test" ]]; then
	isTest="true"
	unset arg2;
elif [[ "${arg3}" == "--test" ]]; then
	isTest="true"
	unset arg3;
elif [[ "${arg4}" == "--test" ]]; then
	isTest="true"
	unset arg4;
fi

# allow for listing the commits made
unset listLog;
if [[ "${arg1}" == "--log" || "${arg1}" == "--list" ]]; then
	listLog="true"
	unset arg1;
elif [[ "${arg2}" == "--log" || "${arg1}" == "--list" ]]; then
	listLog="true"
	unset arg2;
elif [[ "${arg3}" == "--log" || "${arg1}" == "--list" ]]; then
	listLog="true"
	unset arg3;
elif [[ "${arg4}" == "--log" || "${arg1}" == "--list" ]]; then
	listLog="true"
	unset arg4;
fi

if [[ "${listLog}" == "true" ]]; then
	git log --oneline;
	exit;
fi

# determine if the second parameter was sent
if [[ -z "${arg2}" ]]; then
	startCommit="${arg1}~1"
	endCommit="${arg1}"
else
	startCommit="${arg1}"
	endCommit="${arg2}"
fi

# determine which files have changed
if ! [[ -z "${arg1}" ]]; then
	linesChanged=`git diff "${startCommit}..${endCommit}" --name-only`
fi

# if we should only list the changes first
# then echo out those changes and stop the program.
if [[ "${isTest}" == "true" ]]; then
	echo "the following are the files that would be uploaded to the gist"
	echo "${linesChanged}"
	exit;
fi

echo "starting to upload commits[${startCommit}:${endCommit}]"

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
		gistURL=`git show "${startCommit}:${line}" | gist -p -c -d "${gistDesc}" -f "${line}"`
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

echo "created gist: ${gistURL}/revisions"