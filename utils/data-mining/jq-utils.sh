brave_find_files_ofType_withKW() {
  BASEDIR="${1}"
  FTYPE="${2}"
  KW_P="${3}"
  KW_C="${4}"

  find ${BASEDIR} -regextype posix-extended \
                  \( -iregex "${KW_P}" \) -type f \
                  \( -exec file "{}" \; \) \
  | grep -iE "${FTYPE}" \
  | jq -R --arg FT "${FTYPE}" 'split(":")
                              | map( . | sub("^[ ]+|[ ]+$"; "") )
                              | { path: .[0],
                                  type: .[1] | capture("(?<d>" + $FT + ")"; "i") | .d | ascii_downcase
                                }' \
  | jq -r '.path | tojson' \
  | xargs grep -iEl "${KW_C}" \
  | xargs -i echo {}:"${KW_C}" \
  | jq -R 'split(":") | {path: .[0], keyword: .[1]}' \
  | jq -sr
}

brave_find_files_ofJson_withKW() {
  BASEDIR="${HOME}/.config/BraveSoftware/brave-browser-*/*"
  FTYPE="json"
  KW_P=".*local[ ]+?state.*"
  KW_C=""

  brave_find_files_ofType_withKW "${BASEDIR}" "${FTYPE}" "${KW_P}" "${KW_C}"
}



fun_join_every_n_lines() {
  BASEDIR=${HOME}/.config/BraveSoftware/brave-browser-*/*

  find ${BASEDIR} -type f  \
      \( -not -iregex '.*Profile\@.*'   \) \
      \(  -exec grep -iEl '.*ghmbel.*' {} \; \
          -exec grep -iEl '.*ghmbel.*' {} \;  \
          -exec echo '1111111111' \; \
      \) \
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

