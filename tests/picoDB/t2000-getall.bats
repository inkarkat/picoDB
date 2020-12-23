#!/usr/bin/env bats

load canned_databases

@test "existing single record table can be gotten" {
    run picoDB --table one-entry --get-all
    [ $status -eq 0 ]
    [ "$output" = "The Foo is 42" ]
}

@test "existing table can be gotten" {
    run picoDB --table some-entries --get-all
    [ $status -eq 0 ]
    [ "$output" = "$(cat -- "${XDG_DATA_HOME}/some-entries")" ]
}

@test "get-all of non-existing table returns 1" {
    run picoDB --table doesNotExist --get-all
    [ $status -eq 1 ]
    [ "$output" = "" ]
}
