#!/bin/bash

if [[ $# != 1 ]] ; then
   echo "Pass directory to add marker to as single paramter"
   exit 1
fi

# This marker is needed for infra publishing
MARKER_TEXT="Project: $ZUUL_PROJECT Ref: $ZUUL_REFNAME Build: $ZUUL_UUID"

echo $MARKER_TEXT > $1/.root-marker
