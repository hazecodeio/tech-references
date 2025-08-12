#https://docs.virustotal.com/reference/analysis

CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

curl  --request GET \
      --URL "https://www.virustotal.com/api/v3/analyses/u-dbaa0e33d0daeb8dcf860c1ec09c5ac4feb1bb164a3d292a2074d37d4c85cde2-1711891238" \
      --header "x-apikey: "${API_VT_KEY}""