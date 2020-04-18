#!/bin/bash
# use this command to run metadata delete - which is the only way to purge fields
# from current checked-out branch 

if [ $# -lt 1 ]
then
    echo 'Usage: source_delete.sh alias'
    exit
fi

ALIAS=$1
NOPROMPT=$2
DEPLOYDIR=$3

if [ -z "$NOPROMPT" ]
then
    echo 'noprompt'
    NOCHECK='-r'
else
    echo 'prompt when deleting'
    
fi

if [ -z "$DEPLOYDIR"  ]
then
    echo 'default destroy dir'
    DEPLOYDIR='destructive/step2'
else
    echo 'new destroy dir'
fi

#validate legacy metadata
# --ignorewarnings is included as warnings are thrown when items in the destructiveChanges.xml do not exist in the org
#                  this happens after the initial run in an environment, and it causes subsequent builds to fail
sfdx force:source:delete $NOCHECK -w 30 --sourcepath $DEPLOYDIR -u $ALIAS
