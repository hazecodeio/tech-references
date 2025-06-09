



fun_join_every_n_lines() {
  BASEDIR=${HOME}/.config/BraveSoftware/brave-browser-*/*

  find ${BASEDIR} \( -not -iregex '.*Profile\@.*'   \) -type f  \
      \( -exec grep -iEl '.*ghmbel.*' {} \; -exec grep -iEl '.*ghmbel.*' {} \;  -exec echo '1111111111' \; \) \
  | jq -R \
  | jq -s '.[]' \
  | jq  '[., input, input]'
}


fun_jq_link_files() {
  BASEDIR=/opt/_tools/spark/spark-current/sbin/

  find ${BASEDIR} -type f \
  | xargs -i jq -n --arg fp {} '{ filepath:$fp,
                                  filename: ($fp|split("/") | .[-1]) }' \
  | jq -rs 'map({  filepath,
                  filename: (["spark", .filename] | join("-")) })' \
  | jq -r '.[] | .filepath, .filename' \
  | xargs -n2 bash -c 'ln -snf $0  $1'
}

#fun_jq_link_files



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

