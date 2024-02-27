# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
source ./_env-loader.sh

curl -H "Authorization: OAuth oauth_consumer_key=\"$KEY_TRELLO\", oauth_token=\"$TOKEN_TRELLO\"" \
  -H 'Accept: application/json' \
	--request PUT \
	--url 'https://api.trello.com/1/cards/ugJwkxmU' \
	-d '{"cover": {"color":"yellow","idAttachment":null,"idUploadedBackground":null,"size":"normal","brightness":"light"}}'

