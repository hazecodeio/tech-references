source ./_env-loader.sh

curl -v -u "$TOKEN_TOGGL" \
	-H "Content-Type: application/json" \
	-d '{"time_entry":{"description":"Meeting with possible clients","duration":300,"start":now,"pid":180942037,"created_with":"curl"}}' \
	-X POST https://api.track.toggl.com/api/v8/time_entries

