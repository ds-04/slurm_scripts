#!/bin/bash

#Author D SIMPSON 2020
#
# Rudimentary Script to generate sreport cluster utilisation for a SLURM cluster from service start to present, on a monthly basis.
# Script handles date/month boundaries and motivation is simply to run through sreport/history quickly.
# This can be run from login nodes or somewhere with access to sreport.
#
#

SERVICE_YEAR_START="2018" #year when your slurm service started / first accepted jobs
SERVICE_MONTH_START="7" #month when service started

CURRENT_MONTH=`date '+%m'`
CURRENT_YEAR=`date '+%Y'`

for y in $(eval echo {$SERVICE_YEAR_START..$CURRENT_YEAR})
do
  for m in {1..12}; do
    #ignore anything earlier than start dates
    if [ $y -eq $SERVICE_YEAR_START ] && [ $m -lt $SERVICE_MONTH_START ]; then
    :
    #Otherwise gather upto current year/month
    elif [ $y -lt ${CURRENT_YEAR} ] || [ $y -eq ${CURRENT_YEAR} -a $m -le $CURRENT_MONTH ]; then
    
    #Calculate if needed
    NUM_DAYS=`cal $m $y | awk 'NF {DAYS = $NF}; END {print DAYS}'`
    
    #Get integer for next month (end date)
    mplus=$((m+1))

    #Sort out padding/eading zero for sreport
      if [ $m -lt 10 ]; then
      mdouble=`printf "%01d"$m`
      else
      mdouble=$m
      fi
      if [ $mplus -lt 10 ]; then
      mplusdouble=`printf "%01d"$mplus`
      else
      mplusdouble=$mplus
      fi
    
    #Deal with december, report end date goes into new year (new year's day midnight)
    if [ $m -eq 12 ]; then
    yplus=$((y+1))
    sreport cluster utilization start=$y-$mdouble-01 end=$yplus-01-01 -t hourper -P
    #Otherwise end date is simply first day next month
    else
    sreport cluster utilization start=$y-$mdouble-01 end=$y-$mplusdouble-01 -t hourper -P
    fi

    fi
  done
done
