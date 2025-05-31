
_INPUT(){
    cat <<EOF

    [
          "Vilazodon:lime",
          "Duloxetine:red",
          "Fluoxetine:green",
          "ADMET:grey",
          "Herbs:purple",
          "Grapefruit:grey",
          "Ginger:grey",
          "Hibiscus:grey",
          "CYP450:grey",
          "Half-Life:grey",
          "ROS:grey",
          "Cancer:grey",
          "Phytochemicals:grey",
          "Catechols:grey",
          "Hydroxyzine:grey",
          "Methylphenidate:grey",
          "SSRI:purple",
          "SNRI:red",
          "MTHFR:grey",
          "Glutathionee:grey",
          ""
    ]

EOF
}


OUT="$(echo "$(_INPUT)" |  jq -rc 'map(split(":") | select(length > 0)) | tojson')"; echo $OUT

#OUT_FLATTENED="$(echo $OUT | jq -r '.[] | join(" ") | tojson' | jq -r)"; echo $OUT_FLATTENED
OUT_FLATTENED="$(echo $OUT | jq -r 'flatten | .[] | tojson' | jq -r)"; echo $OUT_FLATTENED


# Multiple args per single line. Notice the "bash -c '...'"
echo $OUT_FLATTENED | xargs -n2 bash -c 'echo "name:$0 -> color:$1"'

# Multiple args per n line. Notice the "bash -c '...'"
#echo $OUT_FLATTENED | xargs -L2 bash -c 'echo "name:$0 -> color:$1"'