#!/bin/bash

props=$(find ~/dev/api-calls-sandbox -type f -regex '.*.properties' | xargs cat)
#echo $props
f1=($(echo ""$props | jq -Rr '. | split(" ") | .[]' ))
#props=$( IFS=:; printf '%s' "${props[@]}" )

#echo "${f1[0]}"

for prop in "${f1[@]}"; do
  ff=($(echo $prop | jq -Rr '. | split("=") | .[]'))
  fff="${ff[0]}=\"${ff[1]}\""
  . $fff

done
#export props


#f=($(echo $props | jq -Rr '. | split(" ") | .[]' ))
#f=$(printf '%s:' "${f[*]}")
#export f2="$( printf '%q ' "${f[@]}" )"




#echo "${f2[*]}"
#export "${f2[@]}"
#export $(f2)