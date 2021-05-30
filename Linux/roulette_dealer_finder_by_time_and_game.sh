#!/bin/bash

find -type f -iname $3*

grep Hour $3* | awk -F" " '{print $1,$2,$3,$4}'

grep $1 $3* | grep -i $2 | awk -F" " '{print $1,$2,$3,$4}'

grep Hour $3* | awk -F" " '{print $1,$2,$5,$6}'

grep $1 $3* | grep -i $2 | awk -F" " '{print $1,$2,$5,$6}'

grep Hour $3* | awk -F" " '{print $1,$2,$7,$8}'

grep $1 $3* | grep -i $2 | awk -F" " '{print $1,$2,$7,$8}'

