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


################## #GroupMapReduce Ops #################

#GroupOp
fun_filepaths_groupby() {
  fun_filepaths_tokenize \
    | jq -r 'map(. += { groupby: .filepathSplits[0:7] }  )' \
    | jq -r 'group_by(.groupby) | to_entries '
}




#MapOp
fun_filepaths_groupby_map() {
  fun_filepaths_groupby \
    | jq -r 'map({
                      groupby: .value[0].groupby,
                      filepathSplits: [.value[].filepathSplits[7:]]
                 })'
}


#ReduceOp
fun_filepaths_groupby_map_reduce() {
  fun_filepaths_groupby_map \
    | jq -r 'map( (.groupby | join("/")) as $g |
                  { groupby: $g,
                    filepathJoined:  (.filepathSplits | map( [$g,  .] | flatten | join("/")) | sort)
                  })'

#                            .filepathSplits[7:] | join("/")] | sort
}





#################### # Diffing # ###################

fun_filepaths_groupby_map_reduce_to_diff() {
  fun_filepaths_groupby_map_reduce \
    | jq -r '.[] as $arr1 |
             .[] as $arr2 |
             foreach $arr1 as $i
                              (0; foreach $arr2 as  $j
                                                    (0; { path_src: $i.groupby,
                                                          path_dst: $j.groupby, diffing: ($i.groupby + " - " + $j.groupby) ,
                                                          diff: ($i.filepathJoined - $j.filepathJoined)
                                                        }
                                                    )
                              )' \
    | jq -r 'select(isempty(.diff[]) == 'false')'
}


#jq '. as $i | [$i.path_src, "/"] | join(.diff[])

#ReduceOp
fun_filepaths_groupby_map_reduce_to_diff_join() {
  fun_filepaths_groupby_map_reduce_to_diff \
  | jq -r '. as $i | $i += {diff_concatenated: [$i.diff[] | [$i.path_src, .] | join ("/")]}'
}


fun_filepaths_groupby_map_reduce_to_diff_join_filter() {
    fun_filepaths_groupby_map_reduce_to_diff_join \
    | jq -r 'select(.path_src | ascii_downcase | contains("queer", "codeio")) | select(.path_dst | ascii_downcase | contains("codeio", "queer"))' \
#    | jq -s '.[0].diff_concatenated[]'
}
