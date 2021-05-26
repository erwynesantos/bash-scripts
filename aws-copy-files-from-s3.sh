#!/bin/bash
#/home/teradata/scripts/aws-copy-files-from-s3.sh
#Server: dpastgdicomp
#Downloads files from S3 Bucket to dpastgdicomp
# ------------ Change values of variables: files, user, group, perm, tdir if needed ---------------- #
# ------------ Make sure to (sudo su -) before executing this script. using sudo su does not recognizing aws as command ---------------- #
#Variable to read List of Files(Array).
# ------------ To Add files: ('<filename>'<space>'<filename>') ---------------- #
files=('dpa_daily_bb_pw_subscriber_extraction_20210321.csv')
#Variables for user, group and permission. change the value if needed.
user="uup_sftp"
group="uup_sftp"
perm="644"
tdir="/sas/sasdata/source/subscriber_info/daily/"
#findf=echo `find ${​​​​​​sdir}​​​​​​/planned_outage* -newermt "2021-02-28 00:00:00" ! -newermt "2021-03-10 00:00:00"`
#regex=".+(\/.+)
#Loop in each files then check if existing in target directory. Copy if not existing. Change owner and group of copied files
for i in ${​​​​​​files[@]}​​​​​​
 do
  if [ -f $tdir$i ]
   then
    echo "Skipping $i file..."
    continue
   else
    echo "Copying File:$i to $tdir"
    aws s3 cp s3://dpa-prod-archive/$i $tdir$i --profile prd_to_stg
    chown "$user:$group" $tdir$i
    chmod "$perm" $tdir$i
    echo "Completed"
  fi
done