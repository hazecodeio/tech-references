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


# tag::fun_print_RegEx[]
fun_print_RegEx() {
  echo '{"RegEx": "(\w+[_]\w+)+\(\)+?[ ]\{+?\n([ ]+.*\n)+^\}$", "RegExRepl": "# tag::$1[]\n$0\n# end::$1[]"}' | jq -Rr
}
# end::fun_print_RegEx[]

#fun_print_RegEx

fun_jsonpaths() {
  find ~/.config/BraveSoftware/brave-browser-*/ \( -iregex '.*Profile\@.*' -iregex '.*Preferences.*'  \) -type f  \( -exec grep -iEl '.*ghmbel.*' {} \;  \)     \
  | xargs -i jq --arg P {} '. + {path: $P}' {} \
  | jq  -s 'include "m"; . as $i | $i | map( { path:.path, jsonpaths: (tostream | select(.[0] | index("ghmbeldphafepmbegfdlkpapadhbakde"))) | select(length > 1) } ) | group_by(.path) | to_entries | map({path :.value[0].path, jsonpaths: [.value[].jsonpaths] })' \

}

fun_jsonpaths_join_by_dot() {
  jq 'map( { path:.path, jsonpaths: ( .jsonpaths | map( [(["", .[0]] | flatten | join(".")), .[1]] ) ) } )'
}


fun_jsonpaths_array() {
  jq 'map( { path:.path, jsonpaths: ( .jsonpaths | map(.[0]) ) } )'
}