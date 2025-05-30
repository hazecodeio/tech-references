BASEDIR=${HOME}/.config/BraveSoftware/brave-browser-*/*
EXT_ID=ghmbeldphafepmbegfdlkpapadhbakde

fun_jsonpaths_key_to_value_array() {

  find ${BASEDIR} \
      \( -iregex '.*Profile\@.*' -iregex '.*Preferences.*'  \) -type f  \
      \( -exec grep -iEl '.*ghmbel.*' {} \;  \)  \
  | xargs -i jq --arg P {} '. + {filepath: $P}' {} \
  | jq --arg kw ${EXT_ID} 'include "m"; {filepath:.filepath, jsonpaths: tostream | select(.[0] | index($kw)) | select(length > 1) }' \
  | jq -s 'group_by(.filepath) | to_entries | map({filepath :.value[0].filepath, jsonpaths: [.value[].jsonpaths] })'

#  NOTE: You still need to slurp the json objects for GroupBy to work.
}


# ToDo - Don't Use
fun_jsonpaths_key_to_value_array_02() {
  find ${BASEDIR} \( -iregex '.*Profile\@.*' -iregex '.*Preferences.*'  \) -type f  \( -exec grep -iEl '.*ghmbel.*' {} \;  \)     \
  | xargs -i jq --arg P {} '. + {filepath: $P}' {} \
  | jq --arg kw ${EXT_ID} -s 'include "m"; map( { filepath:.filepath, jsonpaths: (tostream | select(.[0] | index($kw))) | select(length > 1) } ) | group_by(.filepath) | to_entries | map({filepath :.value[0].filepath, jsonpaths: [.value[].jsonpaths] })' \

#  NOTE: You still need to slurp the json objects for GroupBy to work.
}




fun_jsonpaths_key_to_value_dotted() {
  fun_jsonpaths_key_to_value_array \
  | jq 'map( { filepath:.filepath, jsonpaths: ( .jsonpaths | map( [(["", .[0]] | flatten | join(".")), .[1]] ) ) } )'
}



fun_jsonpaths_key_array() {
  fun_jsonpaths_key_to_value_array \
  | jq 'map( { filepath:.filepath, jsonpaths: ( .jsonpaths | map(.[0]) ) } )'
}

fun_jsonpaths_key_dotted() {
  fun_jsonpaths_key_to_value_dotted \
  | jq 'map( { filepath:.filepath, jsonpaths: ( .jsonpaths | map(.[0]) ) } )'
}


fun_jsonpaths_delete_leaves() {
  OUT=$(fun_jsonpaths_key_array | jq -r '.[0].jsonpaths | tojson')

  cat ${HOME}/.config/BraveSoftware/brave-browser-*/Profile@*Queerly*/Preferences \
  | jq --argjson P ${OUT} 'delpaths($P)' \
#  | jq --arg kw ${EXT_ID} '.extensions.settings | {ghmbeldphafepmbegfdlkpapadhbakde}' | grep -i '\|ghmbeldphafepmbegfdlkpapadhbakde'
}


fun_jsonpaths_delete_parent() {
  OUT=$(fun_jsonpaths_key_array | jq --arg kw ${EXT_ID} -r '.[0].jsonpaths | map(.[:index($kw)+1]) | tojson')

  cat ${HOME}/.config/BraveSoftware/brave-browser-*/Profile@*Queerly*/Preferences \
  | jq --argjson P ${OUT} 'delpaths($P)' \
#  | jq --arg kw ${EXT_ID} '.extensions.settings | {ghmbeldphafepmbegfdlkpapadhbakde}' | grep -i '\|ghmbeldphafepmbegfdlkpapadhbakde'
}








# https://pmc.ncbi.nlm.nih.gov/articles/PMC11426367/table/TAB3/
fun_html_table_to_json() {
#  cat $HOME/temp/table.html | xq '.tbody'
  cat ${HOME}/temp/table.html | xq '.tbody.tr[0].td | map({"#text"} | with_entries(.key = .key)) | map(."#text") as $h | $h'
}