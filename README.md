![](https://github.com/OnStageDevelopment/.github/blob/main/images/drop_pulley_control.png?raw=true)



# This Program is still in alpha. Do not expect it to be stable.

This program runs on a computer connected to a rope pulley via a electric motor and can control the movement of the pulley.



It contains its own initial setup procedure which downloads and generates the required files. It is also auto updated each time the computer is run. A example config file can be found in the ```example``` folder in this repository.



This program waits for commands on the RedNet network and commands are sent as JSON. An example command to make all motors on the ```flynet.scenic``` RedNet Protocol go to their configured dead in would be:

```json
{"id":"*","command":"dead_in"}
```

To do the same to only one node, replace the asterisk with its id number:

```json
{"id":1,"command":"dead_in"}
```



In the future a control program will be written but this is the current alpha state.



## To Get Started!

Simply run this code on a new computer with no files to download all the required files and updater: 

```wget run https://raw.githubusercontent.com/OnStageDevelopment/DropPulleyControl/main/startup.lua```

The Computer will then reboot and start the initial setup



### Available Commands

The current commands available in the control API are

```dead_in``` This brings the pulley to its defined dead in position.

```dead_out``` This brings the pulley to its defined dead out position.

```complete_out``` This brings the pulley to its defined furthest state out.

```custom``` *(Requires the ```distance``` argument)* This will set the pulley to whatever height you would like it (within the constraints of the dead in and complete out).

```reboot``` This will restart the node.



### JSON API Arguments

The current arguments for the control API are

```id``` This tells the system what node the command is sent to, either uses the id in integer form *(no ```""```)* or if you would like to send the command to all nodes on that protocol set ```id``` to ```"*"``` .

```command``` This tells the node what to do, available commands are listed above.

```distance``` This argument takes an integer and defines what position the pulley should move too when the ```custom``` command argument is specified, other than that it is ignored and not required for other commands.

```speed``` This  argument takes an integer and defines what speed you would like the motors to run at, it is not a required argument and without it the motor will run at the nodes predefined ```default_speed``` argument.



### Config.json Arguments

When setting up a new node you will need to input a JSON string for it to use as its config. An example of this ```config.json``` file can be found in the ```examples``` folder. An explanation of each argument will be provided below.

```node_network``` *(String)* This defines what RedNet network the node should run on, you can call it whatever you want aslong as there are no spaces.

```type``` *(String)* This defines what type of drop it should be, it is only for connecting to the correct sub-protocol on the RedNet network for organisation. Examples of this include ```scenic``` or ```lx.```

```id``` *(Integer)* This defines what id the node is running it, it cannot be the same as any other node running on the same protocol subnet and is used when receiving commands.

```dead_in``` *(Integer)* This defines the height of the pulley when the load is at the desired height in (towards the stage). It also defines the maximum distance the pulley can go when the ```custom``` command is used.

```dead_out```*(Integer)* This defines the height of the pulley when the load is at the desired height out  (away the stage).

```complete_out``` *(Integer)* This defines the height of the pulley when it is at its highest most point (touching the pulley or stuck of object above it etc). It also defines the maximum distance the pulley can go when the ```custom``` command is used.

```reversed``` *(String)* This defines if all calculations for travel direction should be automatically reversed to achieve all motors traveling in same direction. Currently positive RPM winds the pulley in and negative RPM winds the pulley out. This argument either takes ```true``` or ```false```.

```default_speed``` *(Integer)* This defines the default speed for the motor to run when running commands if a speed is not specified. 



## Join Us On Discord!

This project is very early in its establishment, so please come hang out in the [Discord Server](https://discord.gg/tf4aSRen).