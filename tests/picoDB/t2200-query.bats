#!/usr/bin/env bats

load fixture
load canned_databases

@test "existing single key can be queried" {
    run -0 picoDB --table one-entry --query 'The Foo is 42'
    assert_output ''
}

@test "non-existing key query fails" {
    run -4 picoDB --table one-entry --query notInHere
    assert_output ''
}

@test "key can be queried among many" {
    run -0 picoDB --table some-entries --query bar
    assert_output ''
}

@test "key query is case-sensitive" {
    run -4 picoDB --table some-entries --query FOO
    assert_output ''
}

@test "need a full key match" {
    run -4 picoDB --table some-entries --query oo
    assert_output ''
}

@test "key with underscore in it can be queried" {
    run -0 picoDB --table some-entries --query 'o_O'
    assert_output ''
}
