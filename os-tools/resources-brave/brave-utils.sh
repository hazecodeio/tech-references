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



fun_join_every_n_lines() {
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



