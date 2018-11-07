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

"bootstrap.exe" installs all dependencies required to prepeare the Uppaal jobs execution environment. The "bootstrap.sh" installs UPPAAL  and latest version of JDK. Please note that both UPPAAL and JAVA are installed in "/opt" directory.    

The "main.sh" is a simple script that executes a shell script "run.sh" which must be already available in "INPUT_DIR". It also passes on commmand line arguments i.e. INPUT_DIR and OUTPUT_DIR to "run.sh". 

"cli_parameters" contain all command line options that UPPAAL allows for model-checking. The latest version of UPPAAL includes query properties within the model file. Following is example command to execute a model against UPPAAL:

```
/opt/uppaal64-4.1.19/bin-Linux/verifyta 2doors.xml -o2 -t1 -V 
```  
Thus JSON dictionary to be passed from "Chiminey Protal" for above command to execute this uppaal model would be:

```
{"cli_parameters" : ["2doors.xml -o2 -t1 -V" ] }
```

The Input Directory
-------------------
Each connector in Chiminey system may specify a payload directory that is loaded to each VM for cloud execution. This payload directory content may vary for different runs. It is done through indicating input directory for a specific run. This also allows parameteisation on the input envrionment.  

Configure, Create and Execute a Uppaal Job
------------------------------------------
"Create Job" tab in "Chiminey Portal" lists "uppaal" form for creation and submission of uppaal job. the "uppaal" form require definition of "Compute Resource Name" and "Storage Location". Appropiate "Compute Resource" and "Storage Resource" need to be defined  through "Settings" tab in the "Chiminey portal".

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
