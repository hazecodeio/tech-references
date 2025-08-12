


#DataPrepOp
fun_me_paths_tokenize() {
    BASE_PATH=${HOME}/.config/BraveSoftware/brave-browser-*/Profile@*

    #BASE_NAME=ghmbeldphafepmbegfdlkpapadhbakde
    BASE_NAME=jplgfhpmjnbigmhklmmbgecoobifkmpa
    #BASE_NAME=*

    #KW_RegEx='.*haze.vid.*'
    KW_RegEx='.*.*'


    find $BASE_PATH -name "${BASE_NAME}" \
    | xargs -i find {}  -regextype posix-extended \
                        -iregex $KW_RegEx \
                        -type f  \
    | jq -R 'split("/") as $s | {path_base: ., filename: $s[-1], pathSplits: $s}';  \
}

#fun_me_tokenize_paths

################## #GroupMapReduc Ops #################

#GroupOp
fun_me_paths_groupby() {
  fun_me_paths_tokenize \
  | jq '. += {groupby:.pathSplits[0:7]}' \
  | jq -s 'group_by(.groupby) | to_entries'
}

#fun_me_paths_groupby



#MapOp
fun_me_paths_map_from_groupby() {
  fun_me_paths_groupby \
  | jq 'map({groupby: .value[0].groupby | join("/"), pathSplits: [.value[].pathSplits[7:] | join("/")] | sort})'
}

#fun_me_paths_map_from_groupby

fun_me_paths_diff() {
  fun_me_paths_map_from_groupby \
  | jq ' .[] as $arr1 |
         .[] as $arr2 |
         foreach $arr1 as $i (0; foreach $arr2 as $j (0; {path_src: $i.groupby, path_dst: $j.groupby, diffing: ($i.groupby + " - " + $j.groupby) , diff: ($i.pathSplits - $j.pathSplits)}))' \
  | jq 'select(isempty(.diff[]) == 'false')'
}

#fun_me_paths_diff

#jq '. as $i | [$i.path_src, "/"] | join(.diff[])

#ReduceOp
fun_me_paths_join() {
  fun_me_paths_diff \
  | jq '. as $i | $i += {diff_concatenated: [$i.diff[] | [$i.path_src, .] | join ("/")]}'
}

#fun_me_paths_join

fun_me_paths_filter() {
    fun_me_paths_join \
    | jq 'select(.path_src | ascii_downcase | contains("queer", "codeio")) | select(.path_dst | ascii_downcase | contains("codeio", "queer"))' \
#    | jq -s '.[0].diff_concatenated[]'
}

#fun_me_paths_filter


######################################################
















fun_brave_find_files_with_kw() {
    BASE_PATH=${HOME}/.config/BraveSoftware/brave-browser-*/Profile@*
    #BASE_NAME=ghmbeldphafepmbegfdlkpapadhbakde
    BASE_NAME=*

    #KW_RegEx='.*ghmbeldphafepmbegfdlkpapadhbakde.*'
    KW_RegEx='.*.*'

    KW_C='protonvpn'

    FTYPE=json;

    find $BASE_PATH -name "${BASE_NAME}" \
    | xargs -i find {}  -regextype posix-extended \
                        -iregex $KW_RegEx \
                        -type f \
    | xargs -i file {} \
    | grep -i "${FTYPE}" \
    | jq --arg FT "${FTYPE}" -R 'split(":") | map(.|sub("^[ ]+|[ ]+$"; "")) | {path: .[0], type: .[1] | capture("(?<d>" + $FT + ")"; "i") | .d | ascii_downcase}' \
    | jq '.path' \
    | xargs grep -iE $KW_C -l \
    | xargs -i echo {}:$KW_C \
    | jq -R 'split(":") | {path: .[0], keyword: .[1]}'
}




#fun-brave-find-files-with-kw ()
#{
#    P=$1;
#    FTYPE=$2;
#    KW_RegEx_C=$3;
#    KW_RegEx_P=$4;
#    find ${P} -regextype posix-extended -iregex "${KW_RegEx_P}" -type f -exec file {} + | grep --color=auto -iE "${FTYPE}" | jq --arg FT "${FTYPE}" -R 'split(":") |  map(.|sub("^[ ]+|[ ]+$"; "")) | {path: .[0], type: .[1] | capture("(?<d>"+$FT+")"; "i") | .d | ascii_downcase}' | jq '.path' | xargs grep -iE $KW_RegEx_C -l | xargs -i echo {}:$KW_RegEx_C | jq -R 'split(":") | {path: .[0], keyword: .[1]}'
#}




fun_brave_map_ext() {
    BASE_PATH="${HOME}"/.config/BraveSoftware/brave-browser-*/Profile@*/Extensions/*/*/manifest.json
    KW_C='proton.*vpn'

    find $BASE_PATH \
    | xargs -i jq --arg path "{}" '{short_name: .short_name, name: .name, path: $path, pathSplits: $path|split("/")}' "{}" \
    | jq --arg kw "${KW_C}" 'select([.name, .short_name] | tostring | test($kw; "ig"))'
}
