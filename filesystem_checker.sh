#!/bin/bash
directory=/home/teradata/scripts/filesystemcheck/output
find_save(){
        if [ $(df / --output=pcent | awk -F '%' 'NR==2{print $1}') -ge 75 ] ;
        then
        echo "/ FS util => 75%";
        echo "Running checker now";
        find / -xdev -type f -exec du -sh {} ';' | sort -rh | head -50 > $directory/STG-$HOSTNAME-util-`date '+%Y-%m-%d_%H:%M:%S'`.log;
        #chown teradata.admin $directory/*;
        fi;
}

scp_mail(){
scp  $directory/* thakral@dpastgmo:/home/thakral/scripts/filesystemcheck/
ssh -t thakral@dpastgmo 'echo "STG-dpastgespkwik01 / filesystem util breaching 80%" | mailx -v -r fs_utilbot@globe.com.ph -s "STG-dpastgespkwik01 / filesystem util breaching 80%" -a /home/thakral/scripts/filesystemcheck/* "zecvista@globe.com.ph,zemsantos@globe.com.ph,zrtangpus@globe.com.ph,zgqtorres@globe.com.ph,zhcvenal@globe.com.ph"'
}

rm_files(){
rm $directory/*
ssh thakral@dpastgmo 'rm /home/thakral/scripts/filesystemcheck/*'
}

if pgrep -x "find" > /dev/null
then
        echo "Already running, waiting next 5 minutes"
else
        echo "Stopped, running now. Please wait to finish.."
        find_save
        scp_mail
        rm_files
fi
