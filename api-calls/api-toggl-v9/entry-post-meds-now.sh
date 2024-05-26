source ./_env-loader.sh

curl -v -u "$TOKEN_TOGGL" \
	-H "Content-Type: application/json" \
	-d '{"description":"Meeting with possible clients","workspace_id":4561855,"duration":300,"start":"2024-05-26T08:11:13.558395752Z","project_id":180942037,"created_with":"curl"}' \
	-X POST https://api.track.toggl.com/api/v9/workspaces/4561855/time_entries

