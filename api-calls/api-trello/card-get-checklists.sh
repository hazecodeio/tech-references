# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
source ./_env-loader.sh

export CARD_ID=ugJwkxmU
export CARD_ID=UAHsXfjc
export CARD_ID=SvJ6mWD9

export CARD_ID=NAejvFiD
#export CARD_NAME=df

curl  -H "Authorization: OAuth oauth_consumer_key=\"$KEY_TRELLO\", oauth_token=\"$TOKEN_TRELLO\"" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X GET \
      --url "https://api.trello.com/1/cards/$CARD_ID/checklists" \
      | jq