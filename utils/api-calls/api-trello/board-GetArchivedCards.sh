# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

BOARD_ID=5b0c36886df89b91a195f6cb

FIELDS=id,name,closed,url,idBoard,idOrganization

FILTER=closed
# Valid values: all, closed, none, open, visible
# closed == archived

curl  -H "Authorization: OAuth oauth_consumer_key=\"${TRELLO_KEY}\", oauth_token=\"${TRELLO_TOKEN}\"" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X GET \
      --URL "https://api.trello.com/1/boards/${BOARD_ID}/cards/${FILTER}?fields=${FIELDS}" \
      | jq \
#      | jq '.[].closed'