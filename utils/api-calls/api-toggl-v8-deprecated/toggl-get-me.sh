CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

curl -v -u "${TOGGL_TOKEN}" \
	-X GET https://api.track.toggl.com/api/v8/me
