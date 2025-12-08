#!/usr/bin/env bats

load fixture
load canned_databases

readDatabase()
{
    eval "$(picoDB --table one-entry --get-as-dictionary myDict "$@")"
}

@test "record table can be gotten from inside a function gets lost because of the declaration within the function" {
    typeset -A myDict=()
    readDatabase
    assert_equal ${#myDict[@]} 0
}

@test "table can be gotten from inside a function by omitting the declaration" {
    typeset -A myDict=()
    readDatabase --omit-declaration
    assert_equal ${#myDict[@]} 1
    assert_equal "${myDict['The Foo is 42']}" t
}
