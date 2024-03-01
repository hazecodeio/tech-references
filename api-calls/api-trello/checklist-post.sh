# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
source ./_env-loader.sh

export BOARD_NAME="QueerFolxCode-Tracking"
export BOARD_ID="5f21eea50f40e30520c6cda3"
export LIST_NAME="Dump"
export LIST_ID="62978c0194afec07a10b04d3"


jsonPayload(){
cat <<EOF

{
  "name": "Stories",
  "pos": "top"
}

EOF
}

curl  -H "Authorization: OAuth oauth_consumer_key=\"$KEY_TRELLO\", oauth_token=\"$TOKEN_TRELLO\"" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X POST \
      --url "https://api.trello.com/1/cards/65e13766e33e71c81f2a7562/checklists" \
      -d "$(jsonPayload)" \

