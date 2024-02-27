# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
source ./_env-loader.sh

curl -H "Authorization: OAuth oauth_consumer_key=\"$KEY_TRELLO\", oauth_token=\"$TOKEN_TRELLO\"" \
        'https://api.trello.com/1/boards/62470ab7abf993216824ec69/lists' \
        | jq '.[] | select(.name != "xyz") | {name: .name, id: .id}'
