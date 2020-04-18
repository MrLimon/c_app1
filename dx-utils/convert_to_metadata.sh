#!/bin/bash
#convert the dx metadata to traditional 
#metadata format in a ./deploy dir

if [ $# -lt 1 ]
then
    DEPLOYDIR='deploy'
    ROOTDIR='force-app/main/'
else
    DEPLOYDIR=$1
    ROOTDIR=$2
fi



sfdx force:source:convert -r $ROOTDIR -d $DEPLOYDIR
