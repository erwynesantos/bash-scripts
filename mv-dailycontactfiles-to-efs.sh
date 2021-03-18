#!/bin/bash
# Moves all dpa_daily_contact_policy_extract_${today}*.csv" files to /appl/di_shareddata/di_files/source/subscriber_info/daily/ (EFS)
ssh_notify(){
ssh -t teradata@dpastgmo 'echo "dpastgdicomp successfully copied dpa_daily_contact_policy_extract to /appl/di_shareddata/di_files/source/subscriber_info/daily/" | mailx -v -r copydpafile@globe.com.ph -s "STG-dpastgdicomp / dpastgdicomp successfully copied dpa_daily_contact_policy_extract to /appl/di_shareddata/di_files/source/subscriber_info/daily/" "zjladra@globe.com.ph,zecvista@globe.com.ph,zemsantos@globe.com.ph,zrtangpus@globe.com.ph,zgqtorres@globe.com.ph,zhcvenal@globe.com.ph"'
}

# Change date format to YYYYmmdd then add to $today variable
year=$(date +%Y)
mon=`date +%m`
day=`date +%d`
today=${year}$mon$day

# Set variables for source file and target file
source=/sas/sasdata/source/subscriber_info/daily/
target=/appl/di_shareddata/di_files/source/subscriber_info/daily/
today=${year}$mon$day
file="dpa_daily_contact_policy_extract_${today}*.csv"

# Check if there's duplicated file before copying
if [ ! -f $target$file ]
 then
  echo "Copying $file..."
  cp $source$file $target
  echo "$source$file successfully copied to $target"
  echo `chown sassvcdi:sassvcdi $target$file`
  ssh_notify
 else
  echo "$file Already Exists"
fi