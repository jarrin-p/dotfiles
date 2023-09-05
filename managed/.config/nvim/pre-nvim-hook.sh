#!/bin/sh

conf="${HOME}/.config/nvim"
lrm_store_path=/tmp/fnl_compile
last_recorded_mtime_path=${lrm_store_path}/last_recorded_mtime
mkdir -p ${lrm_store_path}
touch ${last_recorded_mtime_path}

function get_most_recently_updated () {
    find -E "${conf}/" \
        -not -type d \
        -and \( -name '*.fnl' -or -name '*.lua' \) \
        | xargs -P0 -I{} stat --format='%Z' {} \
        | sort --reverse \
        | head --lines=1
}

# todo: escape period.
most_recently_updated=$(get_most_recently_updated)
last_recorded_mtime=$(cat ${last_recorded_mtime_path})
# echo "last recorded mtime path : ${last_recorded_mtime_path}"
# echo "last recorded mtime      : ${last_recorded_mtime}"
# echo "most recently updated    : ${most_recently_updated}"

if test "${most_recently_updated}" != "${last_recorded_mtime}" \
    || test -z "${last_recorded_mtime}"
then
    echo "found changes"
    find -E . -not -type d -and -name '*.fnl' \
        |  {
            while read -r file_path
            do
                out=$(echo "${file_path}" | sed -E 's/.fnl/.lua/')
                fennel --compile "${file_path}" > "${out}" &
            done
            wait
        }
    get_most_recently_updated > "${last_recorded_mtime_path}"
fi
