# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

BOARD_NAME="Desktop"
BOARD_ID="5b0c36886df89b91a195f6cb"


_INPUT(){
    cat <<EOF

    [
          "Vilazodon:lime",
          "Duloxetine:red",
          "Fluoxetine:green",
          "ADMET:grey",
          "Herbs:purple",
          "Grapefruit:grey",
          "Ginger:grey",
          "Hibiscus:grey",
          "CYP450:grey",
          "Half-Life:grey",
          "ROS:grey",
          "Cancer:grey",
          "Phytochemicals:grey",
          "Catechols:grey",
          "Hydroxyzine:grey",
          "Methylphenidate:grey",
          "SSRI:purple",
          "SNRI:red",
          "MTHFR:grey",
          "Glutathionee:grey",
          ""
    ]

EOF
}


OUT="$(echo "$(_INPUT)" |  jq -rc 'map(split(":") | select(length > 0)) | tojson')"; echo $OUT

#OUT_FLATTENED="$(echo $OUT | jq -r '.[] | join(" ") | tojson' | jq -r)"; echo $OUT_FLATTENED
OUT_FLATTENED="$(echo $OUT | jq -r 'flatten | .[] | tojson' | jq -r)"; echo $OUT_FLATTENED


# Multiple args per single line. Notice the "bash -c '...'"
echo $OUT_FLATTENED | xargs -n2 bash -c 'echo "name:$0 -> color:$1"'

# Multiple args per n line. Notice the "bash -c '...'"
#echo $OUT_FLATTENED | xargs -L2 bash -c 'echo "name:$0 -> color:$1"'







#for i in $OUT_FLATTENED; do
##  for j in {0..1}; do
##      if [ $j -eq 0 ]; then
#        echo name:$i;
##      elif [ $j -eq 1 ]; then
##         echo color:$i;
##      fi
##  done;
#done;

#echo $OUT | jq -c \
#          | jq -s 'to_entries | map({"label": .value[0], "color": .value[1]})'


LABEL_NAME=Vilazodone
LABEL_COLOR=lime

#curl  -H "Authorization: OAuth oauth_consumer_key=\"${TRELLO_KEY}\", oauth_token=\"${TRELLO_TOKEN}\"" \
#      -H "Accept: application/json" \
#      -H "Content-Type: application/json" \
#      -X POST \
#      --URL "https://api.trello.com/1/labels?name=${LABEL_NAME}&color=${LABEL_COLOR}&idBoard=${BOARD_ID}" \
#      | jq \



