BASEDIR=/opt/_tools/spark/spark-current/sbin/

fun_jq_link_files() {
  find ${BASEDIR} -type f \
  | xargs -i jq -n --arg fp {} '{ filepath:$fp,
                                  filename: ($fp|split("/") | .[-1]) }' \
  | jq -rs 'map({  filepath,
                  filename: (["spark", .filename] | join("-")) })' \
  | jq -r '.[] | .filepath, .filename' \
  | xargs -n2 bash -c 'ln -snf $0  $1'
}

#fun_jq_link_files