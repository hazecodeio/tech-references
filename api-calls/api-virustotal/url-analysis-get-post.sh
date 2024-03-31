#https://docs.virustotal.com/reference/analysis

source ./_env-loader.sh

curl  --request GET \
      --url "https://www.virustotal.com/api/v3/analyses/u-dbaa0e33d0daeb8dcf860c1ec09c5ac4feb1bb164a3d292a2074d37d4c85cde2-1711891238" \
      --header "x-apikey: $API_KEY_VT"