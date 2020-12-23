#!/usr/bin/env bats

load temp_database

@test "delete action with no table prints message and usage instructions" {
    run picoDB --delete foo
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: No TABLE passed.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "an allowed empty delete key is accepted but not found" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run picoDB --table "$BATS_TEST_NAME" --allow-empty-key --delete ""
    [ $status -eq 4 ]
}

@test "a delete on a non-existing database fails" {
    clean_table "$BATS_TEST_NAME"

    run picoDB --table doesNotExist --delete whatever

    [ $status -eq 1 ]
    [ "$output" = "" ]
    ! table_exists "$BATS_TEST_NAME"
}
