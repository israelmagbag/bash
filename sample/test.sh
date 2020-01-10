#!/bin/bash

files=("ayan" "grace" "ako")

for fname in ${files[*]}

do
    touch /workspace/bash/sample/$fname.txt
done