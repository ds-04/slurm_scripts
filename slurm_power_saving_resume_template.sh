#!/bin/bash

# Author D SIMPSON 2022

# SLURM POWER SAVING
# ResumeProgram - this is a reference/template

LOGFILE="/var/log/slurm_power_saving/power_save_up.log"

echo "`date` Resume invoked $0 $*" >> "${LOGFILE}"
hosts=`scontrol show hostnames $1`
for host in $hosts
do
   echo "----------------- RESUME LOG ENTRY ${host} -----------------" >> "${LOGFILE}"
   SOME_IPMI_CMD ${host} poweron >> "${LOGFILE}" 2>&1
   sleep 220s #time allowance for booting up before we mount
   SOME_SSH_CMD ${host} "uptime" >> "${LOGFILE}" 2>&1 #get uptime before mount for reference
   SOME_SSH_CMD+MOUNT ${host} >> "${LOGFILE}" 2>&1 || exit 1 #mount this FS before starting slurmd on a node
   sleep 2s #breath
   SOME_SSH_CMD ${host} "systemctl start slurmd" >> "${LOGFILE}" 2>&1 || exit 1 #start slurm on node
   echo "----------------- END OF RESUME LOG ENTRY ${host} -----------------" >> "${LOGFILE}"
done
