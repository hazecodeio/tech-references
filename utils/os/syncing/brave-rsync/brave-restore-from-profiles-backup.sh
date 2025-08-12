CWD=$(echo $(realpath "${0}") | xargs dirname)
#echo "${CWD}"
source "${CWD}"/_env-loader.sh

mkdir -p ${BRAVE_DST}
rsync -avzhruP --delete \
  --include-from=./properties/.rsync-profiles-includes \
  --exclude-from=./properties/.rsync-profiles-excludes \
  ${BRAVE_PROFILES_DST}/ ${BRAVE_SRC}/