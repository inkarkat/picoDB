#!/usr/bin/env bats

load fixture
load canned_databases

@test "existing records for two tables can be gotten into the same dict" {
    eval "$(picoDB --table one-entry --get-as-dictionary myDict)"
    assert_equal ${#myDict[@]} 1
    assert_equal "${myDict['The Foo is 42']}" t

    eval "$(picoDB --table some-entries --get-as-dictionary myDict)"
    assert_equal ${#myDict[@]} 6
    assert_equal "${myDict['The Foo is 42']}" t
    assert_equal "${myDict['foo']}" t
    assert_equal "${myDict['baz']}" t

    eval "$(PICODB_DICT_VALUE=abc picoDB --table one-entry --get-as-dictionary myDict)"
    assert_equal ${#myDict[@]} 6
    assert_equal "${myDict['The Foo is 42']}" abc
    assert_equal "${myDict['foo']}" t
}

@test "clearing the dict between queries" {
    eval "$(picoDB --table one-entry --get-as-dictionary myDict)"
    assert_equal ${#myDict[@]} 1
    assert_equal "${myDict['The Foo is 42']}" t

    myDict=()
    eval "$(picoDB --table some-entries --get-as-dictionary myDict)"
    assert_equal ${#myDict[@]} 5
    assert_equal "${myDict['The Foo is 42']}" ''
    assert_equal "${myDict['foo']}" t
    assert_equal "${myDict['baz']}" t
}
