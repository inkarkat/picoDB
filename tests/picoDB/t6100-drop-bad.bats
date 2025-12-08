#!/usr/bin/env bats

load fixture

@test "drop action with no table prints message and usage instructions" {
    run -2 picoDB --drop
    assert_line -n 0 'ERROR: No TABLE passed.'
    assert_line -n 2 -e '^Usage:'
}

@test "a drop of a non-existing database fails" {
    run -1 picoDB --table doesNotExist --drop
    assert_output ''
}
