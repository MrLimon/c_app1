#!/bin/bash
#use this command when deleting a branch and it's associated scratch org

if [ $# -lt 1 ]
then
    echo Usage: delete_branch.sh branchname
    exit
fi

#run the delete scratch org script
./dx-utils/delete_scratch_org.sh $1

#this should be changed to integration branch
git checkout master

#delete the local branch
git branch -D $1;

#delete the remote branch
git push origin --delete $1;


#display current branch name
git branch

#pull latest from remote origin
git pull

