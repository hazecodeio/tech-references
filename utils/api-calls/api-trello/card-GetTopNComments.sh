# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
# https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-actions-get
# https://developer.atlassian.com/cloud/trello/guides/rest-api/action-types/
# https://developer.atlassian.com/cloud/trello/guides/rest-api/nested-resources/

CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

CARD_ID=ee6N8GbE
ACTIONS_LIMIT=10

#https://trello.com/1/cards/64f0c7decf6a8ab096564717?fields=id&actions=commentCard%2CcopyCommentCard%2CcreateCard%2CcreateInboxCard%2CcopyCard%2CcopyInboxCard&actions_display=true&action_reactions=true&actions_limit=1000

date

curl  -H "Authorization: OAuth oauth_consumer_key=\"${TRELLO_KEY}\", oauth_token=\"${TRELLO_TOKEN}\"" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X GET \
      --URL "https://api.trello.com/1/cards/"${CARD_ID}"?fields=id&actions=commentCard,text,copyCommentCard&actions_limit=${ACTIONS_LIMIT}" \
      | jq \
      | jq '.actions[].id'
