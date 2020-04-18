#!/bin/bash
#use this script to add any custom configuration, data or metadata

if [ $# -lt 1 ]
then
    echo Usage: customize_scratch_org.sh alias
    exit
fi

echo "Customizing Scratch Org: $1"

## assign any required permission sets
#sfdx force:user:permset:assign -n TBD

#run anonymous apex scripts 
sfdx force:apex:execute -f dx-utils/apex-scripts/get_username.cls -u $1

#generate a password for default user
#this is used by puppet 
sfdx force:user:password:generate

sfdx force:org:display --verbose  --json > scratch_org_info.json

sfdx force:user:display --json > scratch_user_info.json

sfdx force:org:open --json -r > scratch_auth_info.json

#create a new type of user

./dx-utils/create_user.sh $1 standard