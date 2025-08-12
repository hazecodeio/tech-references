CWD=$(echo $(realpath "${0}") | xargs dirname)
#echo "${CWD}"
source "${CWD}"/_env-loader.sh


jsonPayload(){
  cat <<EOF

  {
    "type": "m.login.password",
    "identifier": {
      "type": "m.id.user",
      "user": "${MATRIX_USER_ID}"
    },
    "password": "${MATRIX_PASSWORD}"
  }

EOF
}

curl  -H "Accept: application/json" \
      -H "Content-Type: application/json" \
      -X POST \
      --URL "${MATRIX_BASE_URL}"/_matrix/client/v3/login \
      -d "$(jsonPayload)" \
      | jq \
