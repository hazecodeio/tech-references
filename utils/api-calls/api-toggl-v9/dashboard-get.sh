CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

curl -v -u "${TOGGL_TOKEN}" \
	-X GET 'https://api.track.toggl.com/api/v9/workspaces/'"${WORKSPACE_ID}"'/dashboard/all_activity' \
  | jq  '.[]'
