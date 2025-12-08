#!/usr/bin/env bats

load fixture
load temp_database

@test "existing database can be truncated and is empty then" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    run -0 picoDB --table "$BATS_TEST_NAME" --truncate
    assert_equal ${#lines[@]} 0
    table_exists "$BATS_TEST_NAME"
    assert_row_count 0
}

@test "truncate of empty database is a no-op" {
    initialize_table "$BATS_TEST_NAME" from empty

    run -0 picoDB --table "$BATS_TEST_NAME" --truncate
    assert_equal ${#lines[@]} 0
    table_exists "$BATS_TEST_NAME"
    assert_row_count 0
}

@test "truncate of a non-existing table initializes it as an empty file" {
    clean_table "$BATS_TEST_NAME"

    picoDB --table "$BATS_TEST_NAME" --truncate

    table_exists "$BATS_TEST_NAME"
    assert_row_count 0
}

