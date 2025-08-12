CWD=$(echo $(realpath "${0}") | xargs dirname)
#echo "${CWD}"
source "${CWD}"/_env-loader.sh

mkdir -p ${BRAVE_DST}
rsync -avzhruP --delete \
  --include-from=./properties/.rsync-ext-sessionbuddy-includes \
  --exclude-from=./properties/.rsync-ext-sessionbuddy-excludes \
  ${BRAVE_SRC}/ ${BRAVE_EXT_SESSION_BUDDY_DST}