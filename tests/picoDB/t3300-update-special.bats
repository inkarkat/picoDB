#!/usr/bin/env bats

load fixture
load temp_database

@test "update action with no table prints message and usage instructions" {
    run -2 picoDB --update "quux"
    assert_line -n 0 'ERROR: No TABLE passed.'
    assert_line -n 2 -e '^Usage:'
}

@test "update of a table with an empty key is not accepted by default" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run -2 picoDB --table "$BATS_TEST_NAME" --update ""
    assert_output 'ERROR: Empty KEY not allowed.'
    assert_row_count 1
}

@test "update of a table with an empty key is accepted with --allow-empty-key" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run -0 picoDB --table "$BATS_TEST_NAME" --allow-empty-key --update ""
    assert_table_row "$BATS_TEST_NAME" \$ ""
    assert_row_count 2
}

@test "update of a table starting with 1 is accepted" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run -0 picoDB --table "$BATS_TEST_NAME" --update "1more number is valid at start"
    assert_table_row "$BATS_TEST_NAME" \$ "1more number is valid at start"
}

@test "update of a table with - in key is accepted" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run -0 picoDB --table "$BATS_TEST_NAME" --update "x-y dash is valid"
    assert_table_row "$BATS_TEST_NAME" \$ "x-y dash is valid"
}

@test "update of a table with * key is accepted" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run -0 picoDB --table "$BATS_TEST_NAME" --update "*=asterisk is valid"
    assert_table_row "$BATS_TEST_NAME" \$ "*=asterisk is valid"
}

@test "update of a table with key with spaces is accepted" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run -0 picoDB --table "$BATS_TEST_NAME" --update "x y=space is valid"
    assert_table_row "$BATS_TEST_NAME" \$ "x y=space is valid"
}

@test "update of a table with key with newline is accepted" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run -0 picoDB --table "$BATS_TEST_NAME" --update $'x\ny=space is valid'
    assert_table_row "$BATS_TEST_NAME" \$ 'x\ny=space is valid'
}
