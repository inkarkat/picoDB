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

@test "existing special character table can be gotten" {
    run picoDB --table special --get-as-dictionary myDict
    [ $status -eq 0 ]
    eval "$output"

    [ "${myDict['The Foo is 42']}" = t ]
    # Note: Bash associative array does not support empty keys.
    [ "${myDict['x=y']}" = t ]
    [ "${myDict['x-y']}" = t ]
    [ "${myDict['x*y']}" = t ]
    [ "${myDict['x y ']}" = t ]
    [ "${myDict[$'x\n']}" = t ]
    [ "${myDict['1more']}" = t ]
    [ "${myDict['/']}" = t ]
    [ "${myDict['\']}" = t ]
    [ "${myDict['???']}" = t ]
    [ "${myDict['*']}" = t ]
    [ "${myDict['[a-z]*']}" = t ]
    [ "${myDict['{a,b}']}" = t ]
    [ "${myDict['/slashed\']}" = t ]
    [ "${myDict[$'multi\nline\n\ntext']}" = t ]
    [ "${myDict[$'\n']}" = t ]
    [ "${myDict['tabbed	text']}" = t ]
    [ "${myDict['"double-quoted"']}" = t ]
    [ "${myDict["'single-quoted'"]}" = t ]
    [ "${myDict["mi\"x'd\"-quoted"]}" = t ]
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
