#!/bin/bash
FILE=testfile.txt
FILENAME=testfile.txt
SIZE=$(stat --printf="%s" $FILE)
SLACK_UPLOAD_API=https://slack.com/api/files.getUploadURLExternal
SLACK_COMPLETE_API=https://slack.com/api/files.completeUploadExternal
TOKEN=xoxb-12345-6789-0000
CHANNEL_ID=C0123456789
MSG_TITLE="Test Message"

curl -s -F files=$FILE -F filename=$FILENAME -F token=$TOKEN -F length=$SIZE https://slack.com/api/files.getUploadURLExternal > upload.json

# jq run
FILE_ID=$(jq -r .file_id upload.json)
UPLOAD_URL=$(jq -r .upload_url upload.json)

curl -F  filename="@$FILENAME" -H "Authorization: Bearer $TOKEN" -v POST $UPLOAD_URL

echo "****************************"
echo $FILE_ID
echo $UPLOAD_URL
echo "****************************"

UPLOAD=$(jq -r '.upload_url' upload.json)
id=$(jq -r '.file_id' upload.json)
echo $UPLOAD
echo $id

curl -X POST \  -H "Authorization: Bearer $TOKEN" \
	     -H "Content-Type: application/json" \
	          -d '{
        "files": [{"id":"'"$id"'", "title":"'"$MSG_TITLE"'"}],
	        "channel_id": "'"$CHANNEL_ID"'"
		      }'   $SLACK_COMPLETE_API
