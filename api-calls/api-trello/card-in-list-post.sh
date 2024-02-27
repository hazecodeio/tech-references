# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
source ./_env-loader.sh

curl -H "Authorization: OAuth oauth_consumer_key=\"$KEY_TRELLO\", oauth_token=\"$TOKEN2_TRELLO\"" \
     --request POST \
     --url 'https://api.trello.com/1/cards?idList=62470ab7abf993216824ec6a' \
     -d '{
            "key": "",
            "token": "",
            "name": "Hello From cURL",
            "desc": "Hello From cURL",
            "idList": "62470ab7abf993216824ec6a"
        }'
