#!/usr/bin/env bats

load temp_database

@test "update of a table with two new keys in unified argument form adds both records" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    picoDB --table "$BATS_TEST_NAME" --update "This has been added" --update "And this, too"

    assert_table_row "$BATS_TEST_NAME" 1 "The Foo is 42"
    assert_table_row "$BATS_TEST_NAME" 2 "This has been added"
    assert_table_row "$BATS_TEST_NAME" 3 "And this, too"
}

@test "update of a table with two existing keys in unified argument form succeeds but adds nothing" {
    initialize_table "$BATS_TEST_NAME" from some-entries
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 5 ]

    picoDB --table "$BATS_TEST_NAME" --update "bar" --update "Foo"

    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 5 ]
    assert_table_row "$BATS_TEST_NAME" 2 "Foo"
    assert_table_row "$BATS_TEST_NAME" 3 "bar"
}

@test "update of a table with two out of four existing keys in unified argument form adds just the missing keys " {
    initialize_table "$BATS_TEST_NAME" from some-entries
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 5 ]

    picoDB --table "$BATS_TEST_NAME" --update "bar" --update "new" --update "Foo" --update "also new"

    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 7 ]
    assert_table_row "$BATS_TEST_NAME" 2 "Foo"
    assert_table_row "$BATS_TEST_NAME" 3 "bar"
    assert_table_row "$BATS_TEST_NAME" 6 "new"
    assert_table_row "$BATS_TEST_NAME" \$ "also new"
}
