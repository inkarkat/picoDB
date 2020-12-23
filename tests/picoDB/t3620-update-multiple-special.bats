#!/usr/bin/env bats

load temp_database

@test "update of a table with two out of four existing special keys in unified argument form adds just the missing keys " {
    initialize_table "$BATS_TEST_NAME" from special
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 21 ]

    picoDB --table "$BATS_TEST_NAME" --update "???" --update "**" --update \\ --update //\\\\

    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 23 ]
    assert_table_row "$BATS_TEST_NAME" 11 "???"
    assert_table_row "$BATS_TEST_NAME" 10 \\\\
    assert_table_row "$BATS_TEST_NAME" 22 "**"
    assert_table_row "$BATS_TEST_NAME" \$ //\\\\\\\\
}
