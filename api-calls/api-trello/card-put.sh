# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
source ./_env-loader.sh

CARD_ID=zIMl69o3

curl -H "Authorization: OAuth oauth_consumer_key=\"$KEY_TRELLO\", oauth_token=\"$TOKEN_TRELLO\"" \
  -H 'Accept: application/json' \
	--request PUT \
	--url "https://api.trello.com/1/cards/$CARD_ID" \
	-d '{"cover": {"color":"yellow","idAttachment":65de059d6c0cda16e85f9c1d,"idUploadedBackground":null,"size":"normal","brightness":"light"}}'

