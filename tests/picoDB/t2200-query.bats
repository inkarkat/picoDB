#!/usr/bin/env bats

load canned_databases

@test "existing single key can be queried" {
    run picoDB --table one-entry --query 'The Foo is 42'
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "non-existing key query fails" {
    run picoDB --table one-entry --query notInHere
    [ $status -eq 4 ]
    [ "$output" = "" ]
}

@test "key can be queried among many" {
    run picoDB --table some-entries --query bar
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "key query is case-sensitive" {
    run picoDB --table some-entries --query FOO
    [ $status -eq 4 ]
    [ "$output" = "" ]
}

@test "need a full key match" {
    run picoDB --table some-entries --query oo
    [ $status -eq 4 ]
    [ "$output" = "" ]
}

@test "key with underscore in it can be queried" {
    run picoDB --table some-entries --query 'o_O'
    [ $status -eq 0 ]
    [ "$output" = "" ]
}
