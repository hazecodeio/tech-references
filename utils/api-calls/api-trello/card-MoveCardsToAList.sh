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

LIST_ID_DST="680e6ead7c26953e820d4449"

timeStart=$(date)




#FIELDS=all
#QUERY=folate
QUERY=board:5b0c36886df89b91a195f6cb+smrt

PARTIAL=true
MODELTYPES=cards
#MODELTYPES=boards,cards,members,organizations
BOARD_FIELDS=id,closed,dateLastActivity,dateLastView,idOrganization,name,prefs,shortLink,id,name
BOARD_ORGANIZATION=true
BOARD_ORGANIZATION_FIELDS=id,displayName
CARD_FIELDS=id,closed,dateLastActivity,desc,dueComplete,idBoard,isTemplate,name,shortLink,url
CARDS_LIMIT=1000
CARDS_PAGE=0
CARD_BOARD=true
CARD_LIST=true
MEMBER_FIELDS=id,avatarUrl,fullName,initials,nonPublic,username
ORGANIZATION_FIELDS=id,displayName,logoHash,name





OUT=$(curl  -H "Authorization: OAuth oauth_consumer_key=\"${TRELLO_KEY}\", oauth_token=\"${TRELLO_TOKEN}\"" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X GET \
      --URL "https://api.trello.com/1/search?query=${QUERY}&partial=${PARTIAL}&modeltypes=${MODELTYPES}&board_fields=${BOARD_FIELDS}&board_organization=${BOARD_ORGANIZATION}&board_organization_fields=${BOARD_ORGANIZATION_FIELDS}&card_fields=${CARD_FIELDS}&cards_limit=${CARDS_LIMIT}&cards_page=${CARDS_PAGE}&card_board=${CARD_BOARD}&card_list=${CARD_LIST}&member_fields=${MEMBER_FIELDS}&organization_fields=${ORGANIZATION_FIELDS}" \
      | jq -cr '.cards[].name')



echo $OUT | jq -crR 'split(" ")'

#for cardId in $OUT
#do
#  curl  -H "Authorization: OAuth oauth_consumer_key=\"${TRELLO_KEY}\", oauth_token=\"${TRELLO_TOKEN}\"" \
#        -H "Accept: application/json" \
#        -H "Content-Type: application/json" \
#        -X PUT \
#        --URL "https://api.trello.com/1/cards/${cardId}?idList=${LIST_ID_DST}"
#done

timeEnd=$(date)

#echo ${timeStart}
#echo ${timeEnd}

echo '{}' | jq -r \
  --arg S "${timeStart}" \
  --arg E "${timeEnd}" \
  '{
      timeStart: $S,
      timeEnd: $E
  }'