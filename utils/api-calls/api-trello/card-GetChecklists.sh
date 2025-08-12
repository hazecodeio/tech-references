# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

export CARD_ID=ugJwkxmU
export CARD_ID=UAHsXfjc
export CARD_ID=SvJ6mWD9

export CARD_ID=NAejvFiD
#export CARD_NAME=df

curl  -H "Authorization: OAuth oauth_consumer_key=\"${TRELLO_KEY}\", oauth_token=\"${TRELLO_TOKEN}\"" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X GET \
      --URL "https://api.trello.com/1/cards/"${CARD_ID}"/checklists" \
      | jq