#!/bin/bash

for i in {01..75}; do
    idx=`printf '%02d\n' $i`;
    root="quux${idx}"
    mkdir -p $root/data
    mkdir -p $root/aux
    
    touch $root/data/.keep
    touch $root/aux/.keep

    echo "${root}-uri"    > ${root}/archival_object_uri
    echo "${root}-handle" > ${root}/handle
done    
