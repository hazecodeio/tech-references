# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
# https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-actions-get
# https://developer.atlassian.com/cloud/trello/guides/rest-api/action-types/
# https://developer.atlassian.com/cloud/trello/guides/rest-api/nested-resources/

# https://developer.atlassian.com/cloud/trello/rest/api-group-cards/#api-cards-id-actions-idaction-comments-delete

CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

CARD_ID=ee6N8GbE
ACTIONS_LIMIT=10
ACTIONS=commentCard,text #,copyCommentCard

timeStart=$(date)
countBefore=$(.card-GetCommentsCount.sh | jq .comments)

OUT="$(curl  -H "Authorization: OAuth oauth_consumer_key=\"${TRELLO_KEY}\", oauth_token=\"${TRELLO_TOKEN}\"" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X GET \
      --URL "https://api.trello.com/1/cards/"${CARD_ID}"?fields=id&actions=${ACTIONS}&actions_limit=${ACTIONS_LIMIT}" \
      | jq -cr '.actions.[].id')"

echo $OUT | jq -crR 'split(" ")'

for idAction in $OUT
do
  curl  -H "Authorization: OAuth oauth_consumer_key=\"${TRELLO_KEY}\", oauth_token=\"${TRELLO_TOKEN}\"" \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -X DELETE \
        --URL "https://api.trello.com/1/cards/"${CARD_ID}"/actions/"${idAction}"/comments"
done

countAfter=$(.card-GetCommentsCount.sh | jq .comments)

timeEnd=$(date)

#echo ${timeStart}
#echo ${timeEnd}

echo '{}' | jq -r \
  --arg S "${timeStart}" \
  --arg E "${timeEnd}" \
  --arg CB "${countBefore}" \
  --arg CA "${countAfter}" \
  '{
      timeStart: $S,
      timeEnd: $E,
      countBefore: $CB,
      countAfter: $CA
  }'