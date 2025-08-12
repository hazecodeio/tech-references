CWD=$(echo $(realpath "${0}") | xargs dirname)
#echo "${CWD}"
source "${CWD}"/_env-loader.sh

mkdir -p ${BRAVE_DST}
rsync -avzhruP --delete ${BRAVE_SRC} ${BRAVE_DST}
