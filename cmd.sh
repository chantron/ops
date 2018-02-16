#!/bin/bash

cmd-help() {
    local name=$1
    local prefix=$2
    local commands=$(compgen -A function | awk "/^$prefix-/{sub(\"$prefix-\",\"\"); print}")

    echo
    echo "Usage: $name <command>"
    echo
    echo "where <command> is one of:"

    local IFS=$'\n'
    for line in $(echo $commands | awk NF=NF RS= OFS=", " | fold -w 40 -s);
    do
        echo "    $line"
    done

    echo
}

cmd-run() {
    local prefix=$1
    local command="$2"
    shift
    shift

    [[ $(type -t $prefix-help) != 'function' ]]
    local has_help=$?

    [[ $(type -t $prefix-$command) != 'function' ]]
    local has_command=$?

    if [[ ( -z "$command" || $has_command == 0 ) && $has_help == 1 ]]; then
        $prefix-help
        exit
    fi

    $prefix-$command $@
}
