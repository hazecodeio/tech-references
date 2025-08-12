CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

curl -v -u "${TOGGL_TOKEN}" \
	-H "Content-Type: application/json" \
	-d '{"time_entry":{"description":"Meeting with possible clients","duration":300,"start":now,"pid":180942037,"created_with":"curl"}}' \
	-X POST https://api.track.toggl.com/api/v8/time_entries

