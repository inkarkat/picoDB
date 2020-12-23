#!/usr/bin/env bats

load temp_database

@test "update of a table with an existing key does not modify it" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    picoDB --table "$BATS_TEST_NAME" --update "The Foo is 42"

    assert_table_row "$BATS_TEST_NAME" 1 "The Foo is 42"
    assert_table_row "$BATS_TEST_NAME" \$ "The Foo is 42"
}

@test "update of a larger table with an existing key multiple times does not modify it" {
    initialize_table "$BATS_TEST_NAME" from some-entries

    picoDB --table "$BATS_TEST_NAME" --update "foo"
    picoDB --table "$BATS_TEST_NAME" --update "bar"
    picoDB --table "$BATS_TEST_NAME" --update "o_O"

    assert_table_row "$BATS_TEST_NAME" 1 "foo"
    assert_table_row "$BATS_TEST_NAME" 3 "bar"
    assert_table_row "$BATS_TEST_NAME" 4 "o_O"
}
