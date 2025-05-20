BASE_PATH=${HOME}/.config/BraveSoftware/brave-browser-*/Profile@*;



#DataPrepOp
fun_me_paths_tokenize() {
    find $BASE_PATH \
      -regextype posix-extended \
      -iregex '.*' \
      -type f \
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
#      | jq -s '.[0].diff_concatenated[]'
}

#fun_me_paths_filter