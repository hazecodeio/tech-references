# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

BOARD_NAME="Desktop"
BOARD_ID="xZEcS7Kw"
BOARD_ID="5b0c36886df89b91a195f6cb"


FIELDS=all
#FIELDS=id,name,closed,url,idBoard,idOrganization

FILTER=open
# Valid values: all, closed, none, open, visible
# closed == archived

curl  -H "Authorization: OAuth oauth_consumer_key=\"${TRELLO_KEY}\", oauth_token=\"${TRELLO_TOKEN}\"" \
      --URL "https://api.trello.com/1/boards/${BOARD_ID}/lists/${FILTER}?fields=${FIELDS}" \
      | jq -Rr \
