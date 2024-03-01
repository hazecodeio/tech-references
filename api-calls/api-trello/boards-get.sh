# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
source ./_env-loader.sh

export BOARD_NAME="QueerFolxCode-Tracking"
export BOARD_ID="5f21eea50f40e30520c6cda3"

curl  -H "Authorization: OAuth oauth_consumer_key=\"$KEY_TRELLO\", oauth_token=\"$TOKEN_TRELLO\"" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X GET \
      --url "https://api.trello.com/1/members/me/boards" \
      | jq \
           '.[] | select(.name == $ENV.BOARD_NAME) | {name: .name, id: .id}'