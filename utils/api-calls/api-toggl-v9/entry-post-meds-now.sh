CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh


function jsonPayload() {

  local timestamp="$(date "+%Y-%m-%dT%T"-06:00)"

  cat << EOF
  {
      "description":"Meeting with possible clients",
      "workspace_id":'"${WORKSPACE_ID}"',
      "duration":300,
      "start":"${timestamp}",
      "project_id":180942037,
      "created_with":"curl"
  }
EOF
}

curl -v -u "${TOGGL_TOKEN}" \
	-H "Content-Type: application/json" \
	-d  "$(jsonPayload)" \
	-X POST 'https://api.track.toggl.com/api/v9/workspaces/'"${WORKSPACE_ID}"'/time_entries'

