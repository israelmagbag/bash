#!/bin/bash

files="/workspace/bash/sample/f.txt"

for fname in $(cat $files)

do
    touch /workspace/bash/sample/$fname.txt
done