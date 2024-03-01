# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
source ./_env-loader.sh


CARD_ID=ugJwkxmU
CARD_ID=UAHsXfjc
CARD_ID=SvJ6mWD9
CARD_ID=zIMl69o3
CARD_ID=65dffbc3098712790568192b



curl  -H "Authorization: OAuth oauth_consumer_key=\"$KEY_TRELLO\", oauth_token=\"$TOKEN_TRELLO\"" \
      -H 'Accept: application/json' \
      -H 'Content-Type: application/json' \
      -X PUT \
      --url "https://api.trello.com/1/cards/$CARD_ID" \
      -d '{
            "name": "1234",
            "cover": {
              "idUploadedBackground": null,
              "size": "normal",
              "brightness": "light"
            }
          }' | jq

