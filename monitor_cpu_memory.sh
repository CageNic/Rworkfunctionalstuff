#!/bin/bash/env

ps -eo pcpu,pmem,pid,user,args|awk 'BEGIN {print "%CPU\t", "%MEMORY\t", "%USER"}
{OFS="\t"} /rstudio/ && /tier/ && !/bash/ {print $1, $2, $3}'

# creates a better output
ps -eo pcpu,pmem,pid,user,args|awk 'BEGIN {print "%CPU\t", "%MEMORY", "%USER"} /rstudio/ && /tier/ && !/bash/ {print $1"\t", $2"\t", $4}'

# creates a better output
ps -eo user,pmem,args | awk 'BEGIN {print "@USER\t", "%MEMORY"} {OFS="\t"} /rstudio/ && /tier/ && !/(bash|awk)/ {print $1,$2,$3} {sum_var +=$2}; END {print "\n\t\tTOTAL %MEMORY\n\t\t",sum_var};'

# captures the pid and username - using the fields of awk
ps -eo pcpu,pmem,pid,user,args|awk 'BEGIN {print "%CPU\t", "%MEMORY", "PID\t", "%USER"} /rstudio/ && /tier/ && !/bash/ {print $1"\t", $2"\t", $3"\t", $7}'

# describe the process... in this example, rsession
ps -C rsession -o user,pid,cmd,lstart,etime

ps aux --sort=-%mem | head
