#!/usr/bin/env bats

load fixture
load temp_database

@test "delete action with no table prints message and usage instructions" {
    run -2 picoDB --delete foo
    assert_line -n 0 'ERROR: No TABLE passed.'
    assert_line -n 2 -e '^Usage:'
}

@test "an allowed empty delete key is accepted but not found" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run -4 picoDB --table "$BATS_TEST_NAME" --allow-empty-key --delete ""
}

@test "a delete on a non-existing database fails" {
    clean_table "$BATS_TEST_NAME"

    run -1 picoDB --table doesNotExist --delete whatever
    assert_output ''
    run ! table_exists "$BATS_TEST_NAME"
}
