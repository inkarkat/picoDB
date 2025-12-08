#!/usr/bin/env bats

load fixture
load canned_databases

@test "existing single record table can be gotten" {
    run -0 picoDB --table one-entry --get-as-dictionary myDict
    assert_output - <<'EOF'
declare -A myDict
myDict['The Foo is 42']=t
EOF
}

@test "existing table can be gotten" {
    run -0 picoDB --table some-entries --get-as-dictionary myDict
    assert_output - <<'EOF'
declare -A myDict
myDict[foo]=t
myDict[Foo]=t
myDict[bar]=t
myDict[o_O]=t
myDict[baz]=t
EOF
}

@test "existing special character table can be gotten" {
    run -0 picoDB --table special --get-as-dictionary myDict
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
    run -0 picoDB --table empty --get-as-dictionary myDict
    assert_output 'declare -A myDict'
}

@test "get-as-dictionary of non-existing table returns 1" {
    run -1 picoDB --table doesNotExist --get-as-dictionary myDict
    assert_output ''
}

@test "an invalid dict-name is processed just fine (but would cause eval error)" {
    run -0 picoDB --table one-entry --get-as-dictionary 'my&/Dict\#'
    assert_output - <<'EOF'
declare -A my&/Dict\#
my&/Dict\#['The Foo is 42']=t
EOF
}
