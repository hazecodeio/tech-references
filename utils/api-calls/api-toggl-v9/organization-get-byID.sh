CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

#"id": 4535479,
#"name": "HazeOrg"

curl -v -u "${TOGGL_TOKEN}" \
	-X GET 'https://api.track.toggl.com/api/v9/organizations/4535479'
