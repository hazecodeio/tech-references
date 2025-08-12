CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

curl -X POST \
  https://www.wixapis.com/oauth/access \
  -H 'Content-Type: application/json' \
  -d '{
    "grant_type": "authorization_code",
    "client_id": ${CLIENT_SECRET_WIX},
    "client_secret": ${CLIENT_ID_WIX},
    "code": ${XXXX}'
}'
