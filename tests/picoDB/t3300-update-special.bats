#!/usr/bin/env bats

load temp_database

@test "update action with no table prints message and usage instructions" {
    run picoDB --update "quux"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: No TABLE passed.' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "update of a table with an empty key is not accepted by default" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run picoDB --table "$BATS_TEST_NAME" --update ""
    [ $status -eq 2 ]
    [ "$output" = 'ERROR: Empty KEY not allowed.' ]
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 1 ]
}

@test "update of a table with an empty key is accepted with --allow-empty-key" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run picoDB --table "$BATS_TEST_NAME" --allow-empty-key --update ""
    [ $status -eq 0 ]
    assert_table_row "$BATS_TEST_NAME" \$ ""
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 2 ]
}

@test "update of a table starting with 1 is accepted" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run picoDB --table "$BATS_TEST_NAME" --update "1more number is valid at start"
    [ $status -eq 0 ]
    assert_table_row "$BATS_TEST_NAME" \$ "1more number is valid at start"
}

@test "update of a table with - in key is accepted" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run picoDB --table "$BATS_TEST_NAME" --update "x-y dash is valid"
    [ $status -eq 0 ]
    assert_table_row "$BATS_TEST_NAME" \$ "x-y dash is valid"
}

@test "update of a table with * key is accepted" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run picoDB --table "$BATS_TEST_NAME" --update "*=asterisk is valid"
    [ $status -eq 0 ]
    assert_table_row "$BATS_TEST_NAME" \$ "*=asterisk is valid"
}

@test "update of a table with key with spaces is accepted" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run picoDB --table "$BATS_TEST_NAME" --update "x y=space is valid"
    [ $status -eq 0 ]
    assert_table_row "$BATS_TEST_NAME" \$ "x y=space is valid"
}

@test "update of a table with key with newline is accepted" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run picoDB --table "$BATS_TEST_NAME" --update $'x\ny=space is valid'
    [ $status -eq 0 ]
    assert_table_row "$BATS_TEST_NAME" \$ 'x\ny=space is valid'
}
