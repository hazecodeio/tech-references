source ./_env-loader.sh

curl -i -H "Authorization: token $TOKEN_GITHUB" 'https://api.github.com/user/repos'
