source ./_env-loader.sh

#{"id":181557016,"name":"Chores"}

curl -v -u "$TOKEN_TOGGL" \
	-X GET https://api.track.toggl.com/api/v9/workspaces/4561855/projects/181557016 \
	| jq '.'