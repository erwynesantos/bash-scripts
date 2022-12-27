# Located in /home/erwsantos/shellscripts/pingbot-v2.1.0.sh @ this server
# Updated as of Dec 27, 2022 17:55 PHT to v2.1.0

#!/bin/bash

# --------------------------- Variable Definition goes here -------------------------- #
offlog=failed_api.log # Log location
api=(host1.com api2.example.com 192.168.1.1 127.0.0.1) 
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/this-is-not/a-real/web-hook
SLACK_CHANNEL=slack-channel

# ----------------- 'Slack notification' function declaration goes here -------------- #
# Slack color support: good    = green
#                      warning = yellow
#                      danger  = red
# Ref: https://api.slack.com/reference/messaging/attachments

msg_author="PingBot"
msg_pretext="_Reaching APIs..._"
botpic=https://bot-logo.com/logo.png # Upload thumbnail picture on an image hosting service.

send_notification(){
  message="payload={\"channel\": \"#$SLACK_CHANNEL\",\"attachments\":[{\"author_icon\":\"$botpic\",\"author_name\":\"$msg_author\",\"pretext\":\"$msg_pretext\",\"color\":\"$1\",\"text\":\"$2\"}]}"
  curl -X POST --data-urlencode "$message" ${SLACK_WEBHOOK_URL}
}
# -------------- End of 'Slack notification' function declaration --------------------- #

scanPing(){

        for dns in ${api[*]}
    do
        ping -c1 "$dns" > /dev/null
        if [ $? -eq 0 ]; then
        echo "$dns is alive."
        else
        echo "$dns is down."
        fi
    done
}

main(){
    scanPing | grep 'down' > $offlog
}

filechecker(){
if [ -s $offlog ]; then
        # The file is not-empty.
        echo "============================================"
        echo "    Warning: These API(s) are unreachable:    "
        cat $offlog
        send_notification 'danger' "These API(s) are unreachable: \n$(cat $offlog)" # Slack notif
        
        START="$(date +%s)"
        i=0
        while [ $i -le 5 ] # Retry for 10 times, therefore 10*5 = 50 seconds
        do
          retry
          ((i++))
        DURATION=$[ $(date +%s) - ${START} ]
        echo "Time Elapsed: ${DURATION} seconds"
        done
          echo "Critical: API(s) listed above are still unreachable after $DURATION seconds."
          send_notification 'danger' "*Critical: API(s) listed are still unreachable after $DURATION seconds.* \n$(cat $offlog)" # Slack notif
else
        # The file is empty.
        echo "============================================"
        echo "           All APIs are reachable.          "
        send_notification 'good' "All API(s) are reachable." # Slack notif
fi
}

retry(){
        echo "============================================"
        echo "           Retrying to reach API..          "
        scanPing | grep 'down' > $offlog # >-- changes here
        sleep 1

if [ -s $log ]; then
        # The file is not-empty.
        #echo "============================================"
        echo "Critical: These API(s) are still unreachable:  "
        cat $offlog
        # send_notification 'danger' "These APIs are still unreachable: \n$(cat $log)" # Slack notif
        #rm $log
else
        echo "============================================"
        echo "         All APIs are back online.          "
        send_notification 'good' "All API(s) are back online." # Slack notif
        exit 0
fi
}


#---------------- Function call order ----------------#

main 
filechecker
