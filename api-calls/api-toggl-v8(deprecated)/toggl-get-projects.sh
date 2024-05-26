source ./_env-loader.sh

curl -v -u "$TOKEN_TOGGL" \
	-X GET https://api.track.toggl.com/api/v8/workspaces/4561855/projects
