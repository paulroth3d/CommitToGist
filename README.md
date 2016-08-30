# About

Simple shellscript to convert a git commit to a gist.

Either by giving a specific commit or the before and after commit.
<p>Note: adding ~1 to the end of a commit returns the commit before,
ex: 49c52dbbc9b1adfa527ced3b69b5b28575fe32af~1 is the commit before 49c52dbbc9b1adfa527ced3b69b5b28575fe32af)

	. gistCommit.sh 49c52dbbc9b1adfa527ced3b69b5b28575fe32af
	
or

	. gistCommit.sh 49c52dbbc9b1adfa527ced3b69b5b28575fe32af~10 49c52dbbc9b1adfa527ced3b69b5b28575fe32af
	
# Prerequisites

Please note, this uses the excellent Gist command line tool from defunkt:
[https://github.com/defunkt/gist](https://github.com/defunkt/gist/blob/master/README.md#installation)

This also assumes you have the git command line tool within your path.

# To Run

include gistCommit.sh within your path somewhere and then run one of the following:

	#This will create a gist for just that commit
	. gistCommit [[COMMIT SHA]]
	
	ex:
	gistCommit.sh 49c52dbbc9b1adfa527ced3b69b5b28575fe32af
	
or

	#This will create a gist of the files between two commits
	. gistCommit [[COMMIT FROM]] [[COMMIT TO]]
	
	ex:
	. gistCommit.sh 49c52dbbc9b1adfa527ced3b69b5b28575fe32af~10 49c52dbbc9b1adfa527ced3b69b5b28575fe32af

# To Check Before Creating the Gist
(sometimes its best to check what files will be created in the gist beforehand)

	#this will simply list the files that would have been included in the gist.
	. gistCommit.sh --test

# To list the commits available

	#this will list the most recent commits
	. gistCommit.sh --log