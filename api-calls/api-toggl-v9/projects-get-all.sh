source ./_env-loader.sh

curl -v -u "$TOKEN_TOGGL" \
	-X GET https://api.track.toggl.com/api/v9/workspaces/4561855/projects \
	| jq -c '.[] | {id: .id, name: .name}'