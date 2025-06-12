BASEDIR=${HOME}/.config/BraveSoftware/brave-browser-*/*
#EXT_ID=*
#PROFILE='.*'

EXT_ID=.*ghmbeldphafepmbegfdlkpapadhbakde.*
PROFILE=.*Profile@.*



#DataPrepOp
fun_filepaths_tokenize() {


  find ${BASEDIR} -regextype posix-extended  \
        \( -iregex ${EXT_ID} -iregex ${PROFILE}  \) -type f  \
  | jq -R '. | split("/") as $S | {   filepath: .,
                                      filename: $S[-1], filepathSplits: $S
                                  }' \
  | jq -sr


#  find $BASEDIR -name "${EXT_ID}" \
#    | xargs -i find {}  -regextype posix-extended \
#                        -iregex $PROFILE \
#                        -type f  \
#    | jq -R 'split("/") as $s | {filepath: ., filename: $s[-1], filepathSplits: $s}';  \
}


################## #GroupMapReduc Ops #################

#GroupOp
fun_filepaths_groupby() {
  fun_filepaths_tokenize \
    | jq -r 'map(. += { groupby: .filepathSplits[0:7] }  )' \
    | jq -r 'group_by(.groupby) | to_entries '
}




#MapOp
fun_filepaths_groupby_map() {
  fun_filepaths_groupby \
    | jq -r 'map({    filepath: .value[0].filepath,
                      filename: .value[0].filename,
                      groupby: .value[0].groupby | join("/"),
                      filepathJoined: [.value[].filepathSplits[7:] | join("/")] | sort
                 })'
}


fun_filepaths_groupby_map_join() {
  fun_filepaths_groupby_map \
    | jq -r 'map(. as $i |  {   groupby,
                                filepathJoined:  ( .filepathJoined | map(. | [$i.groupby, .] | join("/")) )
                            })'
}





#################### # Diffing # ###################

fun_filepaths_groupby_map_diff() {
  fun_filepaths_groupby_map \
    | jq -r '.[] as $arr1 |
             .[] as $arr2 |
             foreach $arr1 as $i (0; foreach $arr2 as $j (0; {path_src: $i.groupby, path_dst: $j.groupby, diffing: ($i.groupby + " - " + $j.groupby) , diff: ($i.filepathJoined - $j.filepathJoined)}))' \
    | jq -r 'select(isempty(.diff[]) == 'false')'
}


#jq '. as $i | [$i.path_src, "/"] | join(.diff[])

#ReduceOp
fun_filepaths_groupby_map_diff_join() {
  fun_filepaths_groupby_map_diff \
  | jq -r '. as $i | $i += {diff_concatenated: [$i.diff[] | [$i.path_src, .] | join ("/")]}'
}


fun_filepaths_groupby_map_diff_join_filter() {
    fun_filepaths_groupby_map_diff_join \
    | jq -r 'select(.path_src | ascii_downcase | contains("queer", "codeio")) | select(.path_dst | ascii_downcase | contains("codeio", "queer"))' \
#    | jq -s '.[0].diff_concatenated[]'
}
