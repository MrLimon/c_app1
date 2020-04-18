#!/bin/bash
# use this command to retrieve all unpackaged metadata from this org
# in source format from a 
# non-scratch org

if [ $# -lt 1 ]
then
    echo 'Usage: retrieve.sh alias'
    exit
fi



ALIAS=$1

sfdx force:source:retrieve -u $ALIAS  -x "dx-utils/package.xml"
npm run clean-metadata
