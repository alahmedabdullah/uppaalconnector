#!/bin/sh

INPUT_DIR=$1
OUTPUT_DIR=$2

java_exe=$(whereis java 2>&1 | awk '/java/ {print $2}')
java_path=$(dirname $java_exe)

verifyta_exe=$(find /opt -name 'verifyta' 2>&1)

export PATH=$java_path:$PATH

cd $INPUT_DIR

$verifyta_exe $(cat cli_parameters.txt) &> runlog.txt


cp ./*.txt ../$OUTPUT_DIR
# --- EOF ---
