#!/bin/bash
# Updated as of Dec 29, 2022 19:23 EST to v2.1.1
# Fixed bug in retry() as it used to not jump to the else condition when specific APIs were reachable again.

offlog=failed_api.log # Log location
api=(google.com 192.168.1.1 127.0.0.1 youtube.com)
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/not/real/webhook
SLACK_CHANNEL=server-notification
#SLACK_CHANNEL=alertmanager_test # Test channel

# ----------------- 'Slack notification' function declaration goes here -------------- #
# Slack color support: good    = green
#                      warning = yellow
#                      danger  = red
# Ref: https://api.slack.com/reference/messaging/attachments

msg_author="PingBot"
msg_pretext="_Reaching APIs..._"
botpic=https://i.ibb.co/h2zfyx6/wonders-logo.png # Needs to be updated by June 27, 2023

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
        exit 1
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

if [ -s $offlog ]; then
        # The file is not-empty.
        #echo "============================================"
        echo "Critical: These API(s) are still unreachable:  "
        cat $offlog
        # send_notification 'danger' "These APIs are still unreachable: \n$(cat $offlog)" # Slack notif
        #rm $offlog
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