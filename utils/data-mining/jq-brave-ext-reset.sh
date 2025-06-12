source /home/haze/dev/tech-references/utils/data-mining/fun-jsonpaths.sh

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
#  | jq -r --arg kw ${EXT_ID} '.extensions.settings | {ghmbeldphafepmbegfdlkpapadhbakde}' | grep -i '\|ghmbeldphafepmbegfdlkpapadhbakde'

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
#  | jq -r --arg kw ${EXT_ID} '.extensions.settings | {ghmbeldphafepmbegfdlkpapadhbakde}' | grep -i '\|ghmbeldphafepmbegfdlkpapadhbakde'
}












#####################################





# tag::fun_brave_check_extension_dir[]
fun_brave_profile_extension_db() {

  BASEDIR=${HOME}/.config/BraveSoftware/brave-browser-*/*
  PARENT=.*/brave-browser-.*/.*
  PROFILE=.*Profile@.*

  EXT_ID=.*ghmbeldphafepmbegfdlkpapadhbakde.*

  find ${BASEDIR} \
      -regextype posix-extended \
      \( -iregex ${PARENT} -not -iregex '.*Extensions.*' -iregex ${PROFILE} -iregex ${EXT_ID} \) -type f \

#      -exec ls -alhtr --time-style=+'%F %r' {} +;
}
# end::fun_brave_check_extension_dir[]



#fun_brave_check_extension_dir
#fun_loop fun_brave_check_extension_dir


# tag::fun_brave_check_extension_hashes[]
fun_brave_extension_hashes() {

  BASEDIR=${HOME}/.config/BraveSoftware/brave-browser-*/*
  PARENT=.*/brave-browser-.*/.*
  PROFILE=.*Profile@.*

  EXT_ID=ghmbeldphafepmbegfdlkpapadhbakde

  find ${BASEDIR} \
      -regextype posix-extended \
      \( -iregex ${PARENT} -not -iregex ${PROFILE} -iregex '.*json'  \) -type f  \
      \( -exec grep -iEl ${EXT_ID} {} \;  \) \
  | xargs -i jq -r --arg P {} '{path: $P} + .' {}

}
# end::fun_brave_check_extension_hashes[]

#fun_brave_check_extension_hashes

fun_brave_extension_hashes_map() {
  fun_brave_extension_hashes \
  | jq -rs 'map( (.path | split("/")) as $p
                | { path,
                    hashpaths:  .hashes
                                | to_entries
                                | map({ appid: .value.appid,
                                        hash: .key,
                                        hashpath: ( [ $p[:-1] , .key] | flatten | join("/") )
                                      })
                  })'
}

fun_brave_extension_hashes_map_filtered() {

  EXT_ID=ghmbeldphafepmbegfdlkpapadhbakde

  fun_brave_extension_hashes_map \
  | jq -r --arg kw ${EXT_ID} 'map({ path,
                                    hashpaths:  .hashpaths
                                                | map(select(.appid | ascii_downcase | contains($kw)))
                                  })'
}
