source /home/haze/dev/tech-references/utils/data-mining/jq-jsonpaths.sh

BASEDIR=${HOME}/.config/BraveSoftware/brave-browser-*/*

PARENT=.*/brave-browser-.*/.*
PROFILE=.*Profile@.*code.*

#PARENT=
#PROFILE=

EXT_ID=ghmbeldphafepmbegfdlkpapadhbakde

#ToDo - Loop for multiple files

# ToDo - automate with: cd, cp, mkdir, etc... Automate Backing up files being modified
fun_jsonpaths_delete_leaves() {

  OUT=$(fun_jsonpaths_stream_toKeyValue_groupby_mapToKey_filtered \
        | jq -r --arg PROF ${PROFILE} 'map(select(.filepath | test($PROF; "ig") and endswith("Preferences")))')

#  echo $OUT | jq -r 'map({filepath})'
#  echo "-----------------------------------------"

  OUT=$(echo $OUT | jq -r '.[] | .jsonpaths | tojson')
#  echo $OUT

  find ${BASEDIR} -regextype posix-extended  \
        \( -iregex ${PROFILE} -iregex '.*/Preferences$'  \) -type f  \
  | xargs -i cat {} \
  | jq -r --argjson P ${OUT} 'delpaths($P)' \
  | jq -r --arg kw ${EXT_ID} '.extensions.settings | {ghmbeldphafepmbegfdlkpapadhbakde}' | grep -i '\|ghmbeldphafepmbegfdlkpapadhbakde'

}


fun_jsonpaths_delete_parent() {


#  OUT=$(fun_jsonpaths_key_array_filtered | jq -r --arg PROF ${PROFILE} --arg kw ${EXT_ID} '.[] | select(.filepath | test($PROF; "ig") and endswith("Preferences")) | .jsonpaths | map(.[:index($kw)+1]) | tojson')


  OUT=$(fun_jsonpaths_stream_toKeyValue_groupby_mapToKey_filtered \
        | jq -r --arg PROF ${PROFILE} 'map(select(.filepath | test($PROF; "ig") and endswith("Preferences")))')

#  echo $OUT | jq -r 'map({filepath})'
#  echo "-----------------------------------------"

  OUT=$(echo $OUT | jq -r --arg kw ${EXT_ID} '.[] | .jsonpaths | map(.[:index($kw)+1]) | tojson')
#  echo $OUT

  find ${BASEDIR} -regextype posix-extended  \
          \( -iregex ${PROFILE} -iregex '.*/Preferences$'  \) -type f  \
  | xargs -i cat {} \
  | jq -r --argjson P ${OUT} 'delpaths($P)' \
  | jq -r --arg kw ${EXT_ID} '.extensions.settings | {ghmbeldphafepmbegfdlkpapadhbakde}' | grep -i '\|ghmbeldphafepmbegfdlkpapadhbakde'
}












#####################################





# tag::fun_brave_check_extension_dir[]
fun_brave_profile_extension_db() {

  BASEDIR=${HOME}/.config/BraveSoftware/brave-browser-*/*
  PARENT=.*/brave-browser-.*/.*
  PROFILE=.*Profile@.*

  EXT_ID=.*ghmbeldphafepmbegfdlkpapadhbakde.*

  find ${BASEDIR} -type f \
      -regextype posix-extended \
      \(  -not -iregex '.*Extensions.*' \
          -not -iregex '.*tpac.*' \) \
      \(  -iregex ${PARENT} \
          -iregex ${PROFILE} \
          -iregex ${EXT_ID} \) \

#      -exec ls -alhtr --time-style=+'%F %r' {} +;
}
# end::fun_brave_check_extension_dir[]



#fun_brave_check_extension_dir
#fun_loop fun_brave_check_extension_dir


# tag::fun_brave_check_extension_hashes[]
fun_brave_extension_cached() {

  BASEDIR="${HOME}/.config/BraveSoftware/brave-browser-*/*"
  PROFILE=".*Profile@.*"
  NOT_KW=".*tpac.*"

  EXT_ID="ghmbeldphafepmbegfdlkpapadhbakde"

  find ${BASEDIR} -type f  \
      -regextype posix-extended \
      \(  -not -iregex ${PROFILE} \
          -not -iregex ${NOT_KW} \) \
      \(  -iregex '.*json'  \) \
      \( -exec grep -iEl ${EXT_ID} {} \;  \) \
  | xargs -i jq -r --arg P {} '{filepath: $P} + .' {}

}
# end::fun_brave_check_extension_hashes[]

#fun_brave_check_extension_hashes

fun_brave_extension_cached_map() {
  fun_brave_extension_cached \
  | jq -rs 'map( (.filepath | split("/")) as $p
                | { filepath,
                    hashpaths:  .hashes
                                | to_entries
                                | map({ appid: .value.appid,
                                        hash: .key,
                                        hashpath: ( [ $p[:-1] , .key] | flatten | join("/") )
                                      })
                  })'
}

fun_brave_extension_cached_map_filtered() {

  EXT_ID=ghmbeldphafepmbegfdlkpapadhbakde

  fun_brave_extension_cached_map \
  | jq -r --arg kw ${EXT_ID} 'map({ filepath,
                                    hashpaths:  .hashpaths
                                                | map(select(.appid | ascii_downcase | contains($kw)))
                                  })'
}
