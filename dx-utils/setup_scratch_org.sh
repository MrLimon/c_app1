#!/bin/bash
# use this command to create a scratch
# org based on the current branch

#This script should not need to be changed
#please add custom config to customize_scratch_org.sh

if [ $# -lt 1 ]
then
    echo Usage: setup_scratch_org.sh alias
    exit
fi

#create a scratch org for this branch
sfdx force:org:create -s -f config/project-scratch-def.json -a $1;

## push local code artifacts to scratch org
sfdx force:source:push;


#set the default scratch org name
./dx-utils/set_default_scratch_org.sh $1

#add any custom setup steps to:
./dx-utils/customize_scratch_org.sh 


if [ $# -eq 1 ]
then
    # open new scratch org in browser to default page
    sfdx force:org:open -p one/one.app#
    # open new scratch org in browser to default page
    # unless there is an additional arg indicating this is in CI
    exit
fi