# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

BOARD_NAME="Desktop"
BOARD_ID="5b0c36886df89b91a195f6cb"
LABEL_NAME=Vilazodone
LABEL_COLOR=lime

curl  -H "Authorization: OAuth oauth_consumer_key=\"${TRELLO_KEY}\", oauth_token=\"${TRELLO_TOKEN}\"" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X POST \
      --URL "https://api.trello.com/1/labels?name=${LABEL_NAME}&color=${LABEL_COLOR}&idBoard=${BOARD_ID}" \
      | jq \
