BASEDIR=${HOME}/.config/BraveSoftware/brave-browser-*/*
EXT_ID=ghmbeldphafepmbegfdlkpapadhbakde

# ToDo - Separate the GroupBy from the ToStream to its own function
fun_jsonpaths_key_to_value_array() {

  find ${BASEDIR} -regextype posix-extended  \
      \( -iregex '.*Profile\@.*' -iregex '.*/Preferences$'  \) -type f  \
      \( -exec grep -iEl '.*ghmbel.*' {} \;  \)  \
  | xargs -i jq --arg P {} '{filepath: $P, jsonpaths: .}' {} \
  | jq -r 'include "m"; { filepath:   .filepath,
                          jsonpaths:  (.jsonpaths | tostream) }' \
  | jq -rs 'group_by(.filepath) | to_entries
                                | map({ filepath:   .value[0].filepath,
                                        jsonpaths:  [.value[].jsonpaths] })'
}
# NOTE: You still need to slurp the json objects for GroupBy to work.


fun_jsonpaths_key_to_value_dotted() {
  fun_jsonpaths_key_to_value_array \
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
fun_jsonpaths_key_array() {
  fun_jsonpaths_key_to_value_array \
  | jq -r 'map({  filepath:.filepath,
                  jsonpaths: ( .jsonpaths | map(.[0]) ) })'
}

fun_jsonpaths_key_dotted() {
  fun_jsonpaths_key_to_value_dotted \
  | jq -r 'map({  filepath:.filepath,
                  jsonpaths: ( .jsonpaths | map(.[0]) ) })'
}











############# Filtered with KW #################




# ToDo - Add as jq function to the common jq module
fun_jsonpaths_key_to_value_array_filtered() {

  fun_jsonpaths_key_to_value_array \
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


fun_jsonpaths_key_to_value_dotted_filtered() {
  fun_jsonpaths_key_to_value_array_filtered \
  | jq -r 'map({  filepath,
                  jsonpaths: ( .jsonpaths | map( [(.[0] | join(".")), .[1]] ) )
               })'


#  | jq -r 'map({  filepath,
#                  jsonpaths: ( .jsonpaths | map( [(["", .[0]] | flatten | join(".")), .[1]] ) )
#               })'
}


# Use this function to filter out jsonpaths for delpaths() accept an array as a param
fun_jsonpaths_key_array_filtered() {
  fun_jsonpaths_key_to_value_array_filtered \
  | jq -r 'map( { filepath:.filepath, jsonpaths: ( .jsonpaths | map(.[0]) ) } )'
}

fun_jsonpaths_key_dotted_filtered() {
  fun_jsonpaths_key_to_value_dotted_filtered \
  | jq -r 'map( { filepath:.filepath, jsonpaths: ( .jsonpaths | map(.[0]) ) } )'
}










PROFILE=.*Profile@.*codeio.*

# ToDo - automate with: cd, cp, mkdir, etc... Automate Backing up files being modified
fun_jsonpaths_delete_leaves() {

  OUT=$(fun_jsonpaths_key_array_filtered \
        | jq -r --arg PROF ${PROFILE} 'map(select(.filepath | test($PROF; "ig") and endswith("Preferences")))')

#  echo $OUT | jq -r 'map({filepath})'
#  echo "-----------------------------------------"

  OUT=$(echo $OUT | jq -r '.[] | .jsonpaths | tojson')
#  echo $OUT

  find ${BASEDIR} -regextype posix-extended  \
        \( -iregex ${PROFILE} -iregex '.*/Preferences$'  \) -type f  \
  | xargs -i cat {} \
  | jq -r --argjson P ${OUT} 'delpaths($P)' \
#  | jq -r --arg kw ${EXT_ID} '.extensions.settings | {ghmbeldphafepmbegfdlkpapadhbakde}' | grep -i '\|ghmbeldphafepmbegfdlkpapadhbakde'
}


fun_jsonpaths_delete_parent() {


#  OUT=$(fun_jsonpaths_key_array_filtered | jq -r --arg PROF ${PROFILE} --arg kw ${EXT_ID} '.[] | select(.filepath | test($PROF; "ig") and endswith("Preferences")) | .jsonpaths | map(.[:index($kw)+1]) | tojson')


  OUT=$(fun_jsonpaths_key_array_filtered \
        | jq -r --arg PROF ${PROFILE} 'map(select(.filepath | test($PROF; "ig") and endswith("Preferences")))')

#  echo $OUT | jq -r 'map({filepath})'
#  echo "-----------------------------------------"

  OUT=$(echo $OUT | jq -r --arg kw ${EXT_ID} '.[] | .jsonpaths | map(.[:index($kw)+1]) | tojson')
#  echo $OUT

  find ${BASEDIR} -regextype posix-extended  \
          \( -iregex ${PROFILE} -iregex '.*/Preferences$'  \) -type f  \
  | xargs -i cat {} \
  | jq -r --argjson P ${OUT} 'delpaths($P)' \
#  | jq -r --arg kw ${EXT_ID} '.extensions.settings | {ghmbeldphafepmbegfdlkpapadhbakde}' | grep -i '\|ghmbeldphafepmbegfdlkpapadhbakde'
}












# https://pmc.ncbi.nlm.nih.gov/articles/PMC11426367/table/TAB3/
fun_html_table_to_json() {
#  cat $HOME/temp/table.html | xq '.tbody'
  cat ${HOME}/temp/table.html | xq '.tbody.tr[0].td | map({"#text"} | with_entries(.key = .key)) | map(."#text") as $h | $h'
}