UPPAAL Smart Connector for Chiminey
==================================
UPPAAL allows formal model checking of a system modeled as networks of timed automata. 

Verifying a complex uppaal model may become compute-intensive - thus make it a suitable candidate for parallel execution utilising compute resources over the cloud using Chiminey. "Uppaal Smart Connector for Chiminey" allows parameter sweep over uppaal models which facilitates scheduling computes over the cloud for parallel execution.

After the "Uppaal Smart Connector" is activated in Chiminey, the Chiminey portal for Uppaal Samrt Connector allows to configure and submit a UPPAAL job for execution.

UPPAAL Smart Connector Core Function
-----------------------------------
A payload (http://chiminey.readthedocs.io/en/latest/payload.html#payload) provides the core functionality of UPPAAL SC. The payload structure of UPPAAL SC is as following:

```
payload_uppaal/
|--- bootstrap.sh
|--- process_payload
|    |---main.sh
```
The UPPAAL SC needs to install Uppaal binary and Java runtime environment. During activation of UPPAAL SC, the user is required to download appropriate version of uppaal and place in the 'package' directory.

"bootstrap.exe" installs all dependencies required to prepeare the Uppaal jobs execution environment. The "bootstrap.sh" installs UPPAAL  and latest version of JDK. Please note that both UPPAAL and JAVA are installed in "/opt" directory. Following is the content of "bootstrap.sh" for UPPAAL SC:    

```
#!/bin/sh
# version 2.0


WORK_DIR=`pwd`

yum -y update
yum install -y unzip

# Install Java
ext="tar.gz"
jdk_version=8

# how to get the latest oracle java version ref: https://gist.github.com/n0ts/40dd9bd45578556f93e7
cd /opt/
readonly url="http://www.oracle.com"
readonly jdk_download_url1="$url/technetwork/java/javase/downloads/index.html"
readonly jdk_download_url2=$(curl -s $jdk_download_url1 | egrep -o "\/technetwork\/java/\javase\/downloads\/jdk${jdk_version}-downloads-.+?\.html" | head -1 | cut -d '"' -f 1)
[[ -z "$jdk_download_url2" ]] && error "Could not get jdk download url - $jdk_download_url1"

readonly jdk_download_url3="${url}${jdk_download_url2}"
readonly jdk_download_url4=$(curl -s $jdk_download_url3 | egrep -o "http\:\/\/download.oracle\.com\/otn-pub\/java\/jdk\/[7-8]u[0-9]+\-(.*)+\/jdk-[7-8]u[0-9]+(.*)linux-x64.$ext")

for dl_url in ${jdk_download_url4[@]}; do
    wget --no-cookies \
         --no-check-certificate \
         --header "Cookie: oraclelicense=accept-securebackup-cookie" \
         -N $dl_url
done
JAVA_TARBALL=$(basename $dl_url)
tar xzfv $JAVA_TARBALL

UPPAAL_PACKAGE_NAME=$(sed 's/UPPAAL_PACKAGE_NAME=//' $WORK_DIR/package_metadata.txt)  
mv $WORK_DIR/$UPPAAL_PACKAGE_NAME /opt
cd /opt
unzip $UPPAAL_PACKAGE_NAME

cd $WORK_DIR
```

The "main.sh" is a simple script that executes a shell script "run.sh" which must be already available in "INPUT_DIR". It also passes on commmand line arguments i.e. INPUT_DIR and OUTPUT_DIR to "run.sh". Recall that Chiminey sends the path to input (INPUT_DIR) and output (OUTPUT_DIR) directories via command-line arguments<payload>. Here, the SC developer passes on INPUT_DIR, where UPPAAL model file is available. Following is the content of "main.sh" for UPPAAL SC:

```
#!/bin/sh

INPUT_DIR=$1

sh $INPUT_DIR/run.sh $@

# --- EOF ---
```
The "main.sh" executes "run.sh" and passes on values of INPUT_DIR and OPUTPUT_DIR to it. The "run.sh" is template file that must be named as "run.sh_template" and be already made available in INPUT_DIR. "run.sh_template" will be explained further in the following paragraphs. Following is the content of "run.sh_template":

```
#!/bin/sh

INPUT_DIR=$1
OUTPUT_DIR=$2

java_exe=$(whereis java 2>&1 | awk '/java/ {print $2}')
java_path=$(dirname $java_exe)

verifyta_exe=$(find /opt -name 'verifyta' 2>&1)

export PATH=$java_path:$PATH

$verifyta_exe $INPUT_DIR/{{uppaal_model}} {{param_string}} > $OUTPUT_DIR/result
# --- EOF ---
```
So "run.sh_template" file must be located in INPUT_DIR. Since it is a template file, all template tags specified in this file will be replaced by Chiminey with corresponding values that are passed in from "Chiminey Portal" as Json dictionary. This "runs.sh_template" is renamed as "run.sh" when all template tags are replaced by corresponding values. 

"{{uppaal_model}}" is name of the uppaal model file loacated in the input directory, and "{{param_string}}" is the string with all various option that UPPAAL allows for model-checking. The latest version of UPPAAL includes query properties within the model file. For example let's assume we have uppaal model "2doors.xml" (assuming the model file contains all querries to be verified against it). Therefore, following is the command to execute this model against UPPAAL:

```
/opt/uppaal64-4.1.19/bin-Linux/verifyta 2doors.xml -o2 -t1 -V 
```  
Thus JSON dictionary to be passed from "Chiminey Protal" for above command to execute this uppaal model would be:

```
{"cli_parameters" : ["2doors.xml -o2 -t1 -V" ] }
```

The Input Directory
-------------------
Each connector in Chiminey system may specify a payload directory that is loaded to each VM for cloud execution. This payload directory content may vary for different runs. It is done through indicating input directory for a specific run. This also allows parameteisation on the input envrionment.  Any file located in the input directory may be regarded as a template file by adding "_template" suffix. An example template file "run.sh_template" to run an UPPAAL model "2doors.xml" would be:

```
#!/bin/sh

INPUT_DIR=$1
OUTPUT_DIR=$2

java_exe=$(whereis java 2>&1 | awk '/java/ {print $2}')
java_path=$(dirname $java_exe)

verifyta_exe=$(find /opt -name 'verifyta' 2>&1)

export PATH=$java_path:$PATH

$verifyta_exe $INPUT_DIR/{{uppaal_model}} {{param_string}} > $OUTPUT_DIR/result
# --- EOF ---
```
Configure, Create and Execute a Uppaal Job
------------------------------------------
"Create Job" tab in "Chiminey Portal" lists "uppaal_sweep" form for creation and submission of uppaal job. "sweep_uppaal" form require definition of "Compute Resource Name" and "Storage Location". Appropiate "Compute Resource" and "Storage Resource" need to be defined  through "Settings" tab in the "Chiminey portal".

Payload parameter Sweep
----------------------
Parameter sweep for "UPPAAL Smart Connector" in Chiminey System may be performed by specifying appropiate JSON dictionary in "payload parameter sweep" field  of the "uppaal" form. An example JSON dictionary to run parameter sweep for the "2doors.xml" could be as following:

```
{"cli_parameters" : [ "2doors.xml -o1 -t1 -V", "2doors.xml -o2 -t1 -V", "2doors.xml -o3 -t1 -V", "2doors.xml -o1 -t2 -V", "2doors.xml -o2 -t2 -V", "2doors.xml -o3 -t2 -V" ] }
``` 
Above would create six individual process. To allocate maximum two cloud VMs - thus execute three UPPAAL job in each VM,  input fields in "Cloud Compute Resource" for "uppaal" form has to be:

```
Number of VM instances : 2
Minimum No. VMs : 2
```
