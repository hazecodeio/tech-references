#BASEDIR=${HOME}/.config/BraveSoftware/brave-browser-*/*
#EXT_ID=ghmbeldphafepmbegfdlkpapadhbakde

# ToDo - Separate the GroupBy from the ToStream to its own function
fun_jsonpaths_stream_toKeyValue() {




  BASEDIR="${1}"
  WITH_PROFILE="${2}"
  ENDS_WITH="${3}"
  EXT_ID="${4}"


  find ${BASEDIR} -type f  \
      -regextype posix-extended  \
      \(  -iregex "${WITH_PROFILE}" \
          -iregex "${ENDS_WITH}"  \) \
      \(  -exec grep -iEl ${EXT_ID} {} \;  \)  \
  | xargs -i jq --arg P {} '{filepath: $P, jsonpaths: .}' {} \
  | jq -r 'include "m"; { filepath:   .filepath,
                          jsonpaths:  (.jsonpaths | tostream) }' \

}
# NOTE: You still need to slurp the json objects for GroupBy to work.


fun_brave_localstate_jsonpaths_stream_toKeyValue() {

  BASEDIR="${HOME}/.config/BraveSoftware/brave-browser-*/*"
  WITH_PROFILE=".*"
  ENDS_WITH=".*/Local State$"
  EXT_ID="."


  fun_jsonpaths_stream_toKeyValue "${BASEDIR}" "${WITH_PROFILE}" "${ENDS_WITH}" "${EXT_ID}"
}


fun_brave_preferences_jsonpaths_stream_toKeyValue() {

  BASEDIR="${HOME}/.config/BraveSoftware/brave-browser-*/*"
  WITH_PROFILE=".*Profile\@.*"
  ENDS_WITH=".*/Preferences$"
  EXT_ID="ghmbeldphafepmbegfdlkpapadhbakde"


  fun_jsonpaths_stream_toKeyValue "${BASEDIR}" "${WITH_PROFILE}" "${ENDS_WITH}" "${EXT_ID}"
}

fun_jsonpaths_stream_toKeyValue_groupby() {
  fun_brave_preferences_jsonpaths_stream_toKeyValue \
  | jq -rs 'group_by(.filepath) | to_entries
                                | map({ filepath:   .value[0].filepath,
                                        jsonpaths:  [.value[].jsonpaths] })'
}
# NOTE: You still need to slurp the json objects for GroupBy to work.


fun_jsonpaths_stream_toKeyValue_groupby_reduce() {
  fun_jsonpaths_stream_toKeyValue_groupby \
  | jq -r 'map({  filepath:  .filepath,
                  jsonpaths: [ fromstream(.jsonpaths[]) ]
               })' \
  | jq -r 'include "m"; map({ filepath: .filepath,
                              jsonpaths: (.jsonpaths | map(pv))
                            })'



#  | jq 'map( { filepath:   .filepath,             jsonpaths:  ( .jsonpaths
#                            | map(
#                                    [(.[0] | join(".")), .[1]])
#                                    #[(["", .[0]] | flatten | join(".")), .[1]]) # prepend "." to each path.
#                          )
#            })'
}


# Use this function to filter out jsonpaths for delpaths() accept an array as a param
fun_jsonpaths_stream_toKeyValue_groupby_mapToKeys() {
  fun_jsonpaths_stream_toKeyValue_groupby \
  | jq -r 'map({  filepath:.filepath,
                  jsonpaths: ( .jsonpaths | map(.[0]) ) })'
}

fun_jsonpaths_stream_toKeyValue_groupby_mapToKeys_reduce() {
  fun_jsonpaths_stream_toKeyValue_groupby_reduce \
  | jq -r 'map({  filepath:.filepath,
                  jsonpaths: ( .jsonpaths | map(.[0]) ) })'
}

fun_jsonpaths_stream_toKeyValue_groupby_reduce_mapToKeyValue() {
  fun_jsonpaths_stream_toKeyValue_groupby_reduce \
  | jq -r 'map({  filepath:.filepath,
                  jsonpaths: ( .jsonpaths | map( ([.[0], .[1]|tostring] | join(": ") ) ) )} )'
}











############# Filtered with KW #################




# ToDo - Add as jq function to the common jq module
fun_jsonpaths_stream_toKeyValue_groupby_filtered() {

  fun_jsonpaths_stream_toKeyValue_groupby \
  | jq -r --arg kw ${EXT_ID} 'include "m"; map({  filepath,
                                                  jsonpaths: (  .jsonpaths
                                                                | map(  select( [ (.[0] | contains([$kw])) , (.[1] | tostring | contains($kw)) ] | any  )
                                                                        | select(length > 1)
                                                                     )
                                                              )
                                               }) ' \

#| jq --arg kw ${EXT_ID} 'include "m"; map({  filepath, jsonpaths: ( .jsonpaths
#                                                                    | map( select( (.[0]|contains([$kw])) or (.[1]|tostring|contains($kw))  ) | select(length > 1)))
#                                          }) ' \

}


fun_jsonpaths_stream_toKeyValue_groupby_reduced_filtered() {
  fun_jsonpaths_stream_toKeyValue_groupby_filtered \
  | jq -r 'map({  filepath,
                  jsonpaths: ( .jsonpaths | map( [(.[0] | join(".")), .[1]] ) )
               })'


#  | jq -r 'map({  filepath,
#                  jsonpaths: ( .jsonpaths | map( [(["", .[0]] | flatten | join(".")), .[1]] ) )
#               })'
}


# Use this function to filter out jsonpaths for delpaths() accept an array as a param
fun_jsonpaths_stream_toKeyValue_groupby_mapToKey_filtered() {
  fun_jsonpaths_stream_toKeyValue_groupby_filtered \
  | jq -r 'map( { filepath:.filepath, jsonpaths: ( .jsonpaths | map(.[0]) ) } )'
}

fun_jsonpaths_stream_toKeyValue_groupby_mapToKey_reduced_filtered() {
  fun_jsonpaths_stream_toKeyValue_groupby_reduced_filtered \
  | jq -r 'map( { filepath:.filepath, jsonpaths: ( .jsonpaths | map(.[0]) ) } )'
}

fun_jsonpaths_stream_toKeyValue_groupby_mapToKeyValue_reduced_filtered() {
  fun_jsonpaths_stream_toKeyValue_groupby_reduced_filtered \
  | jq -r 'map( { filepath:.filepath, jsonpaths: ( .jsonpaths | map( ([.[0], .[1]|tostring] | join(": ") ) ) )} )'
}



















# https://pmc.ncbi.nlm.nih.gov/articles/PMC11426367/table/TAB3/
fun_html_table_to_json() {
#  cat $HOME/temp/table.html | xq '.tbody'
  cat ${HOME}/temp/table.html | xq '.tbody.tr[0].td | map({"#text"} | with_entries(.key = .key)) | map(."#text") as $h | $h'
}