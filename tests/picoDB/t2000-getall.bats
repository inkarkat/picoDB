#!/usr/bin/env bats

load fixture
load canned_databases

@test "existing single record table can be gotten" {
    run -0 picoDB --table one-entry --get-all
    assert_output 'The Foo is 42'
}

@test "existing table can be gotten" {
    run -0 picoDB --table some-entries --get-all
    assert_output - < "${XDG_DATA_HOME}/some-entries"
}

@test "existing special character table can be gotten" {
    run -0 picoDB --table special --get-all
    assert_output - < "${XDG_DATA_HOME}/special"
}

@test "get-all of non-existing table returns 1" {
    run -1 picoDB --table doesNotExist --get-all
    assert_output ''
}
