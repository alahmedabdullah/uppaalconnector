#!/bin/sh

INPUT_DIR=$1
OUTPUT_DIR=$2

cp run.sh $INPUT_DIR/run.sh
RUN_DIR=`cd "$(dirname "$0")" && pwd`

if [ -e timedata.txt ]
then
    exec_start_time=`date +"%Y-%m-%d %H:%M:%S.%3N"`
    sed -i "s/EXEC_START_TIME/$exec_start_time/" ./timedata.txt
fi 

sh $RUN_DIR/run.sh $@

if [ -e timedata.txt ]
then
    exec_end_time=`date +"%Y-%m-%d %H:%M:%S.%3N"`
    sed -i "s/EXEC_END_TIME/$exec_end_time/" ./timedata.txt
    cp ./timedata.txt $OUTPUT_DIR/timedata.txt
fi 

# --- EOF ---
