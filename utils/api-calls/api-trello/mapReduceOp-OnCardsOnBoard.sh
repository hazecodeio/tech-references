# https://developer.atlassian.com/cloud/trello/guides/rest-api/authorization/#passing-token-and-key-in-api-requests
CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

#./board-GetCardsOnABoard.sh \
cat zz-cards.json \
    | jq '.[].desc | ascii_downcase | split("[\\d\\W_ ]"; "ig")'  \
    | jq --slurpfile v stopwords-en.json -s \
            'flatten
            | group_by(.) | to_entries
            | map({key: .value[0], value: .value | length})
            | map(
                 select(.key | ascii_downcase )
              )
            | sort_by(.value)
            | map(select(.key | contains("folate") | not))'







# | jq '.[].desc | ascii_downcase | split("[\\d\\W_ ]"; "ig")'  \
#    | jq -s  'flatten
#              | group_by(.) | to_entries
#              | map({key: .value[0], value: .value | length})
#              | map(
#                   select(.key | ascii_downcase | contains("fluoxetine","vilazodone","viibryd","cancer","hepatic","pharma"))
#                )
#              | sort_by(.value) | reverse'