#https://docs.virustotal.com/reference/scan-url

CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

curl  --request POST \
      --URL https://www.virustotal.com/api/v3/urls \
      --form url=gazaskygeek.com \
      --header "x-apikey: "${API_VT_KEY}""