#!/usr/bin/env bats

load temp_database

@test "existing database can be truncated and is empty then" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run picoDB --table "$BATS_TEST_NAME" --truncate

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 0 ]
    table_exists "$BATS_TEST_NAME"
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 0 ]
}

@test "truncate of empty database is a no-op" {
    initialize_table "$BATS_TEST_NAME" from empty

    run picoDB --table "$BATS_TEST_NAME" --truncate

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 0 ]
    table_exists "$BATS_TEST_NAME"
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 0 ]
}

@test "truncate of a non-existing table initializes it as an empty file" {
    clean_table "$BATS_TEST_NAME"

    picoDB --table "$BATS_TEST_NAME" --truncate

    table_exists "$BATS_TEST_NAME"
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 0 ]
}

