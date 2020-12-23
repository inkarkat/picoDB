#!/usr/bin/env bats

load temp_database
skip

@test "update of a table with two new keys in unified argument form adds both records" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    nanoDB --table "$BATS_TEST_NAME" --update "one=This has been added" --update "two=And this, too"
    assert_table_row "$BATS_TEST_NAME" 1 "foo=The\ Foo\ is\ 42"
    assert_table_row "$BATS_TEST_NAME" 2 "one=This\ has\ been\ added"
    assert_table_row "$BATS_TEST_NAME" 3 "two=And\ this\,\ too"
}

@test "update of a table with two new keys in separate key-value argument form adds both records" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    nanoDB --table "$BATS_TEST_NAME" --update "one" --value "This has been added" --update "two" --value "And this, too"
    assert_table_row "$BATS_TEST_NAME" 1 "foo=The\ Foo\ is\ 42"
    assert_table_row "$BATS_TEST_NAME" 2 "one=This\ has\ been\ added"
    assert_table_row "$BATS_TEST_NAME" 3 "two=And\ this\,\ too"
}

@test "update of a table with four new keys in mixed argument forms adds all records" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    nanoDB --table "$BATS_TEST_NAME" --update "one=This has been added" --update "two" --value "And this, too" --update "three=the third" --update "four" --value "last"
    assert_table_row "$BATS_TEST_NAME" 1 "foo=The\ Foo\ is\ 42"
    assert_table_row "$BATS_TEST_NAME" 2 "one=This\ has\ been\ added"
    assert_table_row "$BATS_TEST_NAME" 3 "two=And\ this\,\ too"
    assert_table_row "$BATS_TEST_NAME" 4 "three=the\ third"
    assert_table_row "$BATS_TEST_NAME" 5 "four=last"
}
