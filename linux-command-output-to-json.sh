{(echo -e 'c1 c2 c3 c4 c5 c6 c7 c8 c9' & (ls -al ../ | tail -n +2)) } | cat - |
  tr -s ' ' |
    jq -Rcn '
    input   | split(" ")  as $header |
    inputs  | split(" ") |
                    to_entries |
                            map(.key = $header[.key]) | .[0:] | from_entries'




#acc=""
#v=$(seq -w 0 50 300)
#
#for i in $v
#  do acc+=" c_$i"
#done
#
#echo $acc


header=""
temp=$(ls -al ../ | cat - | jq -Rcn 'input | split(" ")  as $temp | $temp | length' | xargs seq -w -s ' ' 1 1)
echo $temp