#!/bin/bash/env

ps -eo pcpu,pmem,pid,user,args|awk 'BEGIN {print "%COU\t", "%MEMORY\t", "%USER"}
{OFS="\t"} /rstudio/ && /tier/ && !/bash/ {print $1, $2, $3}'
