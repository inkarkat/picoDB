#!/usr/bin/env bats

load temp_database

setup()
{
    clean_table "$BATS_TEST_NAME"
}

@test "update of a non-existing table initializes it with the passed key and value" {
    picoDB --table "$BATS_TEST_NAME" --update "key"

    assert_table_row "$BATS_TEST_NAME" 1 "key"
    assert_table_row "$BATS_TEST_NAME" \$ "key"
}
