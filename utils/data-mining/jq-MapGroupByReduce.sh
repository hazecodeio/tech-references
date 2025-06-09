BASEDIR=${HOME}/.config/BraveSoftware/brave-browser-*/*
#BASENAME=*
#KW='.*'

BASENAME=ghmbeldphafepmbegfdlkpapadhbakde
KW='.*Profile@.*'



#DataPrepOp
fun_filepaths_tokenize() {
    find $BASEDIR -name "${BASENAME}" \
      | xargs -i find {}  -regextype posix-extended \
                          -iregex $KW \
                          -type f  \
    	| jq -R 'split("/") as $s | {filepath: ., filename: $s[-1], filepathSplits: $s}';  \
}


################## #GroupMapReduc Ops #################

#GroupOp
fun_filepaths_groupby() {
  fun_filepaths_tokenize \
    | jq '. += {groupby:.filepathSplits[0:7]}' \
    | jq -s 'group_by(.groupby) | to_entries'
}




#MapOp
fun_filepaths_groupby_map() {
  fun_filepaths_groupby \
    | jq 'map({groupby: .value[0].groupby | join("/"), filepathSplits: [.value[].filepathSplits[7:] | join("/")] | sort})'
}


fun_filepaths_groupby_map_join() {
  fun_filepaths_groupby_map \
    | jq 'map(. as $i | { groupby,
                          filepathSplits:  (.filepathSplits as $j | $j
                                            | map(. | [$i.groupby, .] | join("/"))
                                        )})'
}





#################### # Diffing # ###################

fun_filepaths_groupby_map_diff() {
  fun_filepaths_groupby_map \
    | jq ' .[] as $arr1 |
           .[] as $arr2 |
           foreach $arr1 as $i (0; foreach $arr2 as $j (0; {path_src: $i.groupby, path_dst: $j.groupby, diffing: ($i.groupby + " - " + $j.groupby) , diff: ($i.filepathSplits - $j.filepathSplits)}))' \
    | jq 'select(isempty(.diff[]) == 'false')'
}


#jq '. as $i | [$i.path_src, "/"] | join(.diff[])

#ReduceOp
fun_filepaths_groupby_map_diff_join() {
  fun_filepaths_groupby_map_diff \
    | jq '. as $i | $i += {diff_concatenated: [$i.diff[] | [$i.path_src, .] | join ("/")]}'
}


fun_filepaths_groupby_map_diff_join_filter() {
    fun_filepaths_groupby_map_diff_join \
      | jq 'select(.path_src | ascii_downcase | contains("queer", "codeio")) | select(.path_dst | ascii_downcase | contains("codeio", "queer"))' \
#      | jq -s '.[0].diff_concatenated[]'
}
