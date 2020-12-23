#!/usr/bin/env bats

load temp_database

@test "update of a table with a new key adds a record" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    picoDB --table "$BATS_TEST_NAME" --update "This has been added"
    assert_table_row "$BATS_TEST_NAME" 1 "The Foo is 42"
    assert_table_row "$BATS_TEST_NAME" 2 "This has been added"
}

@test "update of a table with new keys twice adds two records" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    picoDB --table "$BATS_TEST_NAME" --update "This has been added"
    picoDB --table "$BATS_TEST_NAME" --update "Another addition"

    assert_table_row "$BATS_TEST_NAME" 1 "The Foo is 42"
    assert_table_row "$BATS_TEST_NAME" 2 "This has been added"
    assert_table_row "$BATS_TEST_NAME" 3 "Another addition"
}
