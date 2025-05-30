#Loop through Extension's Last Modified Timestamp

# tag::fun_loop[]
fun_loop() {
  FUN=$1
  while true; do
        ${FUN};
        echo -e "==============\n";
        sleep 1;
  done
}
# end::fun_loop[]

# tag::fun_print_RegEx[]
fun_print_RegEx() {
  echo '{"RegEx": "(\w+[_]\w+)+\(\)+?[ ]\{+?\n([ ]+.*\n)+^\}$", "RegExRepl": "# tag::$1[]\n$0\n# end::$1[]"}' | jq -Rr
}
# end::fun_print_RegEx[]



fun_join_every_lines() {
  find ${HOME}/.config/BraveSoftware/brave-browser-*/ \( -not -iregex '.*Profile\@.*'   \) -type f  \
      \( -exec grep -iEl '.*ghmbel.*' {} \; -exec grep -iEl '.*ghmbel.*' {} \;  -exec echo '1111111111' \; \) \
  | jq -R \
  | jq -s '.[]' \
  | jq  '[., input, input]'
}



# tag::fun_brave_check_extension_dir[]
fun_brave_check_extension_dir() {
  EXT_ID=ghmbeldphafepmbegfdlkpapadhbakde
  find ${HOME}/.config/BraveSoftware/brave-browser-*/*/*/${EXT_ID}/ \
      -regextype posix-extended -iregex '.*(ldb|lo)' -type f \
      -exec ls -alhtr --time-style=+'%F %r' {} +;
}
# end::fun_brave_check_extension_dir[]



#fun_brave_check_extension_dir
#fun_loop fun_brave_check_extension_dir


# tag::fun_brave_check_extension_hashes[]
fun_brave_check_extension_hashes() {
  EXT_ID=ghmbeldphafepmbegfdlkpapadhbakde
  find ${HOME}/.config/BraveSoftware/brave-browser-*/ \
      \( -not -iregex '.*Profile\@.*' -regex '.*json'  \) -type f  \
      \( -exec grep -iEl ${EXT_ID} {} \;  \) \
  | xargs -i jq --arg P {} '. + {path: $P}' {}
}
# end::fun_brave_check_extension_hashes[]

#fun_brave_check_extension_hashes





fun_jsonpaths_key_to_value_array() {
  EXT_ID=ghmbeldphafepmbegfdlkpapadhbakde;
  find ~/.config/BraveSoftware/brave-browser-*/Profile@Haze*QueerlyFit*/* \( -iregex '.*Profile\@.*' -iregex '.*Preferences.*'  \) -type f  \( -exec grep -iEl '.*ghmbel.*' {} \;  \)     \
  | xargs -i jq --arg P {} '. + {path: $P}' {} \
  | jq --arg kw ${EXT_ID} 'include "m"; {path:.path, jsonpaths: tostream | select(.[0] | index($kw)) | select(length > 1) }' \
  | jq -s 'group_by(.path) | to_entries | map({path :.value[0].path, jsonpaths: [.value[].jsonpaths] })'

#  NOTE: You still need to slurp the json objects for GroupBy to work.
}



fun_jsonpaths_key_to_value_array_02() {
  EXT_ID=ghmbeldphafepmbegfdlkpapadhbakde;
  find ~/.config/BraveSoftware/brave-browser-*/ \( -iregex '.*Profile\@.*' -iregex '.*Preferences.*'  \) -type f  \( -exec grep -iEl '.*ghmbel.*' {} \;  \)     \
  | xargs -i jq --arg P {} '. + {path: $P}' {} \
  | jq --arg kw ${EXT_ID} -s 'include "m"; map( { path:.path, jsonpaths: (tostream | select(.[0] | index($kw))) | select(length > 1) } ) | group_by(.path) | to_entries | map({path :.value[0].path, jsonpaths: [.value[].jsonpaths] })' \

#  NOTE: You still need to slurp the json objects for GroupBy to work.
}

fun_jsonpaths_key_to_value_dotted() {
  fun_jsonpaths_key_to_value_array \
  | jq 'map( { path:.path, jsonpaths: ( .jsonpaths | map( [(["", .[0]] | flatten | join(".")), .[1]] ) ) } )'
}



fun_jsonpaths_key_array() {
  fun_jsonpaths_key_to_value_array \
  | jq 'map( { path:.path, jsonpaths: ( .jsonpaths | map(.[0]) ) } )'
}

fun_jsonpaths_key_dotted() {
  fun_jsonpaths_key_to_value_dotted \
  | jq 'map( { path:.path, jsonpaths: ( .jsonpaths | map(.[0]) ) } )'
}


fun_jsonpaths_delete_leaves() {
  EXT_ID=ghmbeldphafepmbegfdlkpapadhbakde;
  OUT=$(fun_jsonpaths_key_array | jq -r '.[0].jsonpaths | tojson')

  cat ${HOME}/.config/BraveSoftware/brave-browser-*/Profile@*Queerly*/Preferences \
  | jq --argjson P ${OUT} 'delpaths($P)' \
#  | jq --arg kw ${EXT_ID} '.extensions.settings | {ghmbeldphafepmbegfdlkpapadhbakde}' | grep -i '\|ghmbeldphafepmbegfdlkpapadhbakde'
}


fun_jsonpaths_delete_parent() {
  EXT_ID=ghmbeldphafepmbegfdlkpapadhbakde;
  OUT=$(fun_jsonpaths_key_array | jq --arg kw ${EXT_ID} -r '.[0].jsonpaths | map(.[:index($kw)+1]) | tojson')

  cat ${HOME}/.config/BraveSoftware/brave-browser-*/Profile@*Queerly*/Preferences \
  | jq --argjson P ${OUT} 'delpaths($P)' \
#  | jq --arg kw ${EXT_ID} '.extensions.settings | {ghmbeldphafepmbegfdlkpapadhbakde}' | grep -i '\|ghmbeldphafepmbegfdlkpapadhbakde'
}








# https://pmc.ncbi.nlm.nih.gov/articles/PMC11426367/table/TAB3/
fun_html_table_to_json() {
#  cat $HOME/temp/table.html | xq '.tbody'
  cat $HOME/temp/table.html | xq '.tbody.tr[0].td | map({"#text"} | with_entries(.key = .key)) | map(."#text") as $h | $h'
}