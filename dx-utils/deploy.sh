#!/bin/bash
# use this command to deploy
# traditional metadata to a
# non-scratch org

if [ $# -lt 1 ]
then
    echo 'Usage: deploy.sh alias <sourcepath> <checkonly> '
    exit
fi



ALIAS=$1
DEPLOYDIR=$2
CHECKONLY=$3
VERBOSEDEPLOY=''

TESTLEVEL='RunLocalTests'
# SPECIFIED_TESTS='ConstantsTest,SelectorTest,DomainTest,DataTest,DescribeCacheTest,DeviceSearchControllerTest,DeviceOrderControllerTest,FindTest,LimitsSnapshotTest,QueryTest,SecUtilTest,UserTest,UserTestFactoryTest'

if [ -z "$CIRCLECI" ]
then
    echo 'verbose deploy'
    VERBOSEDEPLOY='--verbose'
fi

if [ -z "$CHECKONLY" ]
then
    echo 'real deploy'
else
    echo 'checkonly deploy'
    CHECKONLY='-c'
fi

if [ -z "$DEPLOYDIR"  ]
then
    echo 'default sourcepath dir'
    DEPLOYDIR='force-app'
else
    echo 'new sourcepath dir'
fi

sfdx force:source:deploy -u $ALIAS $CHECKONLY --sourcepath $DEPLOYDIR $VERBOSEDEPLOY

#sleep 5s

#sfdx force:mdapi:deploy:report -u $ALIAS
