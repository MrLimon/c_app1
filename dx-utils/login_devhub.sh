#!/bin/bash

 
if [ $# -lt 1 ]
then
    HUBALIAS='dev-hub'
else
    HUBALIAS=$1
fi

sfdx force:auth:web:login --setdefaultdevhubusername -a $HUBALIAS

sfdx force:org:list