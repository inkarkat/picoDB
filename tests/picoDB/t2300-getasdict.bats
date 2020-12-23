#!/usr/bin/env bats

load canned_databases

@test "existing single record table can be gotten" {
    run picoDB --table one-entry --get-as-dictionary myDict
    [ $status -eq 0 ]
    [ "$output" = "declare -A myDict
myDict['The Foo is 42']=t" ]
}

@test "existing table can be gotten" {
    run picoDB --table some-entries --get-as-dictionary myDict
    [ $status -eq 0 ]
    [ "$output" = 'declare -A myDict
myDict[foo]=t
myDict[Foo]=t
myDict[bar]=t
myDict[o_O]=t
myDict[baz]=t' ]
}

@test "empty commented table has the declaration only" {
    run picoDB --table empty --get-as-dictionary myDict
    [ $status -eq 0 ]
    [ "$output" = 'declare -A myDict' ]
}

@test "get-as-dictionary of non-existing table returns 1" {
    run picoDB --table doesNotExist --get-as-dictionary myDict
    [ $status -eq 1 ]
    [ "$output" = "" ]
}

@test "an invalid dict-name is processed just fine (but would cause eval error)" {
    run picoDB --table one-entry --get-as-dictionary 'my&/Dict\#'
    [ $status -eq 0 ]
    [ "$output" = "declare -A my&/Dict\\#
my&/Dict\\#['The Foo is 42']=t" ]
}
