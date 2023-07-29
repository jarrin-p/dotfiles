#!/bin/sh

stored_hash_path=dot-md5s.json

current=$(find -E . \
    -not -type d \
    -iregex '.*.[fnl|lua]' \
    | xargs -I% md5sum % \
    | xargs -I% jq -rn --arg path % '
        $path
        | split(" ")
        | { key: .[1], value: .[0]}' \
        | jq -s '. | from_entries' \
)

stored=$(cat ${stored_hash_path})

# todo: union current keys with stored keys,
# since right now current keys aren't checked.
changes=$(echo "${current} ${stored}" | jq -rs ' {
        current: .[0],
        stored: .[1]
    }
    | . as $comp
    | .current
    | keys
    | .[]
    | . as $key
    | {
        file: $key,
        current: ( $comp.current | .[($key)] ),
        stored: ( $comp.stored | .[($key)] )
    }
    | . as $joined
    | select ( .current != .stored )
    | .file
    | select ( endswith("fnl") )
    | sub ("\\.fnl"; "")' \
)

if test -z "${changes}"
then
    echo "found fennel changes. recompiling.
    echo $changes | xargs -I% sh -c "fennel --compile %.fnl > %.lua"
fi
