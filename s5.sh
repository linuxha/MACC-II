#!/bin/bash

#
# add an option to add the start address (currently 0000)
#
if [ $# -ne 1 ]; then
    echo "S9 Generator, converts text to S9 Record"
    echo "$0 \"String to convert\""
    exit 1
fi


STR=$(printf "%04X" "${1}")
#STR=$(while read -n 1 a; do printf "%02X" "'$a";done <<< "${STR}")
L=4
CHKSUM=${L}

if [ $L -gt 255 ]; then
    echo "S9 string is too long (${L} chars)"
    exit 1
fi

while read -n 2 a
do
    CHKSUM=$(($CHKSUM+0x${a}))
done <<< "${STR}"

CHKSUM=$(( 255 - (${CHKSUM}&255) ))
printf "S5%02X%s%02X\n" ${L} "${STR}" ${CHKSUM}
