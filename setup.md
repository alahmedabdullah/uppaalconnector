UPPAAL Connector
================

Setup
-----
1. Install Chiminey (https://github.com/chiminey/docker-chiminey)
2. Go to docker-chiminey directory
```
	$ cd docker-chiminey
```
3. Enter into the Chiminey container
```
	$ ./chimineyterm
```
4. Go to chiminey directory
```
	$ cd /opt/chiminey/current/chiminey
```
5. Modify the SMART_CONNECTORES dictionary in settings_change.py file to have following:
```
	'uppaal':  {'init': 'chiminey.uppaalconnector.initialise.UppaalInitial',
             	      'name': 'uppaal',
            	      'description': 'The UPPAAL Model Checker',
             	      'payload': '/opt/chiminey/current/chiminey/uppaalconnector/payload_uppaal',
             	      'sweep': True
                    },
```
6. Modify the INPUT_FIELDS dictionary in settings_change.py file to have following:
```
	'uppaal':  SCHEMA_PREFIX + "/input/uppaal",
```
7. Clone the git repository https://github.com/al-ahmedabdullah/uppaalconnector.git in /opt/chiminey/current/chiminey
```
	$ git clone https://github.com/al-ahmedabdullah/uppaalconnector.git
```
8. Change ownership of the newly created uppalconnector directory
```
	$ chown -R chiminey.nginx uppaalconnector
```
9. Exit from the chiminey container
```
	$ exit
```
10. Restart the chiminey container
```
	$ docker-compose restart chiminey
```
11. Check that uppaal connector is listed in available smart connectors list
```
	$ ./listscs
```
12. Activate the uppaal connector and follow the prompts
```
	$ ./activatesc uppaal
```
