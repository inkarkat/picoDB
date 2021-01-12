#!/usr/bin/env bats

load canned_databases

readDatabase()
{
    eval "$(picoDB --table one-entry --get-as-dictionary myDict "$@")"
}

@test "record table can be gotten from inside a function gets lost because of the declaration within the function" {
    typeset -A myDict=()
    readDatabase
    [ ${#myDict[@]} -eq 0 ]
}

@test "table can be gotten from inside a function by omitting the declaration" {
    typeset -A myDict=()
    readDatabase --omit-declaration
    [ ${#myDict[@]} -eq 1 ]
    [ "${myDict['The Foo is 42']}" = t ]
}
