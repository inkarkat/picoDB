#!/usr/bin/env bats

load temp_database

@test "update of a table is rejected because second key is invalid" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run nanoDB --table "$BATS_TEST_NAME" --update "one=This has been added" --update "*=invalid"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: KEY must be a valid variable name.' ]
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 1 ]
}

@test "update of a table rejected because second unified key comes before first value" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run nanoDB --table "$BATS_TEST_NAME" --update "one" --update "two=And this, too"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Need VALUE to update.' ]
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 1 ]
}

@test "update of a table rejected because second separate key comes before first value" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run nanoDB --table "$BATS_TEST_NAME" --update "one" --update "two" --value "And this, too"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Need VALUE to update.' ]
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 1 ]
}

@test "update of a table rejected because separate value comes before first key" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run nanoDB --table "$BATS_TEST_NAME" --value "what" --update "two=And this, too"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Need KEY to update.' ]
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 1 ]
}

@test "update of a table rejected because no separate value" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run nanoDB --table "$BATS_TEST_NAME" --update "key"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Need VALUE to update.' ]
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 1 ]
}

@test "update of a table rejected because no separate second value after separate first" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run nanoDB --table "$BATS_TEST_NAME" --update "one" --value "This has been added" --update "two"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Need VALUE to update.' ]
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 1 ]
}

@test "update of a table rejected because no separate second value after unified first" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run nanoDB --table "$BATS_TEST_NAME" --update "one=This has been added" --update "two"
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Need VALUE to update.' ]
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 1 ]
}
