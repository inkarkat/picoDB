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

@test "update of a table with two out of four existing multi-line keys in unified argument form adds just the missing keys " {
    initialize_table "$BATS_TEST_NAME" from special
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 21 ]

    picoDB --table "$BATS_TEST_NAME" --update $'\n\n' --update $'\n' --update $'multi\nline\n\ntext' --update $'\nnever\nseen\n'

    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 23 ]
    assert_table_row "$BATS_TEST_NAME" 16 'multi\nline\n\ntext'
    assert_table_row "$BATS_TEST_NAME" 17 '\n'
    assert_table_row "$BATS_TEST_NAME" 22 '\n\n'
    assert_table_row "$BATS_TEST_NAME" \$ '\nnever\nseen\n'
}
@test "update of a table with two out of four existing empty keys in unified argument form adds just the missing keys " {
    initialize_table "$BATS_TEST_NAME" from special
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 21 ]

    picoDB --table "$BATS_TEST_NAME" --allow-empty-key --update $'\n' --update '' --update ' ' --update 'x'

    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 23 ]
    assert_table_row "$BATS_TEST_NAME" 2 ''
    assert_table_row "$BATS_TEST_NAME" 17 '\n'
    assert_table_row "$BATS_TEST_NAME" 22 ' '
    assert_table_row "$BATS_TEST_NAME" \$ 'x'
}
@test "update of a table with two out of four non-existing empty key in unified argument form adds just the missing keys " {
    initialize_table "$BATS_TEST_NAME" from some-entries
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 5 ]

    picoDB --table "$BATS_TEST_NAME" --allow-empty-key --update $'\n' --update 'Foo' --update '' --update 'o_O'

    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 7 ]
    assert_table_row "$BATS_TEST_NAME" 2 'Foo'
    assert_table_row "$BATS_TEST_NAME" 4 'o_O'
    assert_table_row "$BATS_TEST_NAME" 6 '\n'
    assert_table_row "$BATS_TEST_NAME" \$ ''
}
