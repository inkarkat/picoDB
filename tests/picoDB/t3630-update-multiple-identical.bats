#!/usr/bin/env bats

load temp_database

@test "update of a table with two identical new keys in unified argument form adds a single record only" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    picoDB --table "$BATS_TEST_NAME" --update "This has been added" --update "This has been added"

    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 2 ]
    assert_table_row "$BATS_TEST_NAME" 1 "The Foo is 42"
    assert_table_row "$BATS_TEST_NAME" 2 "This has been added"
}

@test "update of a table with two identical new keys out of four in unified argument form adds deduplicated records only" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    picoDB --table "$BATS_TEST_NAME" --update "This is brand new" --update "This has been added" --update "The Foo is 42" --update "This has been added"

    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 3 ]
    assert_table_row "$BATS_TEST_NAME" 1 "The Foo is 42"
    assert_table_row "$BATS_TEST_NAME" 2 "This is brand new"
    assert_table_row "$BATS_TEST_NAME" 3 "This has been added"
}
