# Linux process times

You need to use the ps command to see information about a selection of the active processes. The pid command provide following two formatting options for a PID (process identification number). A PID automatically assigned when process is created on a Linux or Unix-like operating system. Linux ```ps``` command to find process runtimes options:

```etime``` Display elapsed time since the process was started, in the form [[DD-]hh:]mm:ss.
```etimes``` Display elapsed time since the process was started, in seconds.

## How to check how long a process has been running
You need to pass the -o etimes or -o etime to the ps command. The syntax is:
```ps -p {PID-HERE} -o etime```
```ps -p {PID-HERE} -o etimes```

The ps command used to provide information about the currently running processes on Linux, including their process identification numbers (PIDs) and other information. We can use other commands too. For example, pstree command, top command, htop command and more. Let us see examples to find out how long the OpenVPN process has been running on my server.

## Step 1: Find PID of a process (say openvpn)
Open the shell prompt and then type the following pidof command:
```
pidof openvpn
6176
```

## note down the PID 6176.

## Step 2: How long a openvpn process has been running?
```
ps -p 6176 -o etime
```
## OR
```
ps -p 6176 -o etimes
```
## To hide header:
ps -p 6176 -o etime=
ps -p 6176 -o etimes=

The 6176 is the PID of the process you want to check. In this case I’m looking into openvpn process

## print PID, command, elapsed time, user ID, and group ID:
```ps -p 6176 -o pid,cmd,etime,uid,gid```

## Sample outputs:
```
  PID CMD                             ELAPSED   UID   GID
 6176 /usr/sbin/openvpn --daemon        15:25 65534 65534
```

On many production systems, unprivileged users or developers are not allowed to look up process-related information due to security concerns. In such cases, it is necessary to run the ps as root user either using the su command or sudo command

## How to find how long a process named mysqld has run in Linux
Find process id of mysqld by ysing the ps command or pidof command:
```sudo pidof mysqld```

## Alternatively, use the grep command as filter ##
```sudo ps aux | grep '/usr/sbin/[m]ysqld'```

Now, you have the PID for the mysqld, let us find and print the PID creation date. In other words find out when when the process was started on Linux, enter:
```
sudo ps -p {PID} -o start,etimes,etime
sudo ps -p 1861 -o start,etimes,etime
sudo ps -p 1861 -o pid,cmd,start,etimes,etime
```

Our final example directly find PID by giving process name such as lighttpd, nginx, mysqld and so on:
```
sudo ps -C {process-name} -o pid,cmd,start,etimes,etime
sudo ps -C lighttpd -o pid,cmd,start,etimes,etime
sudo ps -C nginx -o pid,cmd,start,etimes,etime
sudo ps -C mysqld -o pid,cmd,start,etimes,etime
```

## How to Find How Long a Process Has Run in Linux
Multiple processes or PID means you are running the same process using Docker/LXD or Linux containers. Same daemons (long-running background process) such as Nginx uses the parent-child process model so you might see many PIDs too. For instance, here is outputs from server that is running multiple Linux containers with php-fpm7 master process per container:

```sudo ps -C php-fpm7 -o pid,cmd,lstart,etime,etimes```

Sample outputs:
```
  PID CMD                                          STARTED     ELAPSED ELAPSED
 5329 php-fpm: master process (/e Sun Feb  2 11:37:30 2020 98-00:47:03 8470023
 8907 php-fpm: pool www           Fri May  1 21:25:46 2020  8-14:58:47  745127
15269 php-fpm: pool www           Wed Apr 15 11:28:58 2020 25-00:55:35 2163335
15271 php-fpm: pool www           Wed Apr 15 11:28:59 2020 25-00:55:34 2163334
```

PID 5329 (php-fpm master process) was started on “Sun Feb 2 11:37:30 2020” and 8470023 seconds ago. The 98-00:47:03 indicates that it was started 98 days ago:

Today’s date when the ps was executed: Sunday, 10 May 2020
PID started on: Sunday, 2 Feb 2020
Time elapsed in seconds: 8470023
Days elapsed: 98 days
Understanding ps options
Linux find how long a process running with ps:

### Finding how long Linux processing has been running with the ps option
### Options	Description	Examples
```
    -C	Select process by command name instead of PID	ps -C firefox
     ps -C memcached
     ps -C redis-server
    -o pid	A number representing the process ID	ps -C nginx -o pid
    ps -p PID_HERE -o pid
    -o cmd	Command with all its arguments as a string	ps -C google-chrome -o cmd
    -o start	Time the command started
If the process was started less than 24 hours ago, the output format is “HH:MM:SS”, else it is ” Mmm dd” (where Mmm is a three-letter month name)	ps -C mysqld -o start
-o lstart	Find time the background command started	ps -C lighttpd -o lstart
-o etimes	Get elapsed time since the process was started, in seconds	ps -C php-fpm7 -o etimes
-o etime	See elapsed time since the process was started, in the form [[DD-]hh:]mm:ss	ps -C php-fpm7 -o etime
-o etime=
-o cmd=
-o $opt=	Hide the ps command header	ps -C php-fpm7 -o pid,cmd,lstart,etimes=
```
