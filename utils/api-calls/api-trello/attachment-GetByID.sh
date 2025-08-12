# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

BOARD_NAME="QueerFolxCode-Tracking"
BOARD_ID="5f21eea50f40e30520c6cda3"
LIST_NAME="Dump"
LIST_ID="62978c0194afec07a10b04d3"

curl  -H "Authorization: OAuth oauth_consumer_key=\"${TRELLO_KEY}\", oauth_token=\"${TRELLO_TOKEN}\"" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X "GET" \
      --URL "https://api.trello.com/1/cards/65d3e089ad0ca85992b13826/attachments/65de0db8e4d66d4176cede30" \
#      | jq
