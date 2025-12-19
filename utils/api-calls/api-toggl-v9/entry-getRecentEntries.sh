CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh


timestamp="1608336970"
START_TIME=""
END_TIME=""

curl -v -u "${TOGGL_TOKEN}" \
	-H "Content-Type: application/json" \
	-X GET 'https://api.track.toggl.com/api/v9/me/time_entries?before='"${timestamp}"

