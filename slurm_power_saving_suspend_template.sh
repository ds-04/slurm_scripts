#!/bin/bash

# Author D SIMPSON 2022

# SLURM POWER SAVING
# SuspendProgram - this is a reference/template

LOGFILE="/var/log/slurm_power_saving/power_save_down.log"

echo "`date` Suspend invoked $0 $*" >> "${LOGFILE}"
hosts=`scontrol show hostnames $1`
for host in $hosts
do
  echo "-----------------SUSPEND LOG ENTRY ${host} -----------------" >> "${LOGFILE}"
  SOME_SSH_CMD+UMOUNT ${host} >> "${LOGFILE}" 2>&1 || exit 1 #always ensure this FS unmounted before node goes down
  SOME_SSH_CMD ${host} "systemctl disable slurmd" >> "${LOGFILE}" 2>&1 || exit 1 #always ensure slurmd disabled before node goes down
  SOME_SSH_CMD ${host} "init 0" >> "${LOGFILE}" 2>&1
  echo "----------------- END OF SUSPEND LOG ENTRY ${host} -----------------" >> "${LOGFILE}"
done
