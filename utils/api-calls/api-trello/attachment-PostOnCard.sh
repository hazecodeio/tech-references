# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

BOARD_NAME="QueerFolxCode-Tracking"
BOARD_ID="5f21eea50f40e30520c6cda3"
LIST_NAME="Dump"
LIST_ID="62978c0194afec07a10b04d3"
CARD_ID=65e0e893303ca7db117b3e03


jsonPayload(){
cat <<EOF

{
  "url": "https://raw.githubusercontent.com/hazecodeio/media-store/main/t-blue.png",
  "setCover": true
}

EOF
}

curl  -H "Authorization: OAuth oauth_consumer_key=\"${TRELLO_KEY}\", oauth_token=\"${TRELLO_TOKEN}\"" \
      -H 'Accept: application/json' \
      -H 'Content-Type: application/json' \
      -X POST \
      --URL "https://api.trello.com/1/cards/${CARD_ID}/attachments" \
      -d "$(jsonPayload)" \
#      | jq
