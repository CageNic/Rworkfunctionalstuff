# Process Schedule Manipulation
## Using nice
The niceness ranges from -20 to 19 and shows the potential of a process being chosen by the CPU to run. We can set this value before launching a process:

``` $ nice -n 19 ./myProcess.sh ```

Here, we set the niceness to 19 and launched myProcess. The higher the niceness, the less the process demands of the scheduler, so this process will be given less CPU time when other processes require the CPU.

## Using renice
To change the niceness value of a process while it’s running, we use a tool called renice:

```
$ ./myProcess.sh && ps aux | grep -i 'myProcess'

baeldung-reader       20935  0.0  0.0   6376  2420 pts/0    S+   10:16   0:00 grep --color=auto -i myProcess
$ renice -n 19 20935
```

In the example above, we launched a process called myProcess, got its PID, and changed its niceness value to 19.
