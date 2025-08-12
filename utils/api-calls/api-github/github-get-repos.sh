CWD=$(echo $(realpath "${0}") | xargs dirname)
#echo "${CWD}"
source "${CWD}"/_env-loader.sh

curl  -H "Authorization: token "${GITHUB_TOKEN}"" \
      -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X GET \
      --URL "${GITHUB_BASE_URL}"/user/repos \
