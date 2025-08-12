CWD=$(echo $(realpath "${0}") | xargs dirname)
#echo "${CWD}"
source "${CWD}"/_env-loader.sh

find ../ -type f -regextype posix-extended -regex "^(../|./|/).*(_env-)*.properties.gpg$" \
  | grep -o '.*[^.gpg]' \
  | xargs -i gpg --passphrase $GPG_PASSPHRASE --yes --batch -o {} -d {}.gpg