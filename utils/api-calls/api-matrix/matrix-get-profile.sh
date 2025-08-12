CWD=$(echo $(realpath "${0}") | xargs dirname)
#echo "${CWD}"
source "${CWD}"/_env-loader.sh

curl  -H "Authorization: Bearer "${MATRIX_TOKEN}"" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X GET \
      --URL "${MATRIX_BASE_URL}"/_matrix/client/v3/profile/"${MATRIX_USER_ID}" \
      | jq \
