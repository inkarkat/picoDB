#!/usr/bin/env bats

load temp_database

@test "update with tab characters" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    picoDB --table "$BATS_TEST_NAME" --update "the	foo	contains		tabs	"
    assert_table_row "$BATS_TEST_NAME" \$ "the	foo	contains		tabs	"
}

@test "update with newlines" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    picoDB --table "$BATS_TEST_NAME" --update "this
goes
over
multiple

lines"
    assert_table_row "$BATS_TEST_NAME" \$ 'this\ngoes\nover\nmultiple\n\nlines'
}

@test "update with single quotes" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    picoDB --table "$BATS_TEST_NAME" --update "with O'Brian in 'here'"
    assert_table_row "$BATS_TEST_NAME" \$ "with O'Brian in 'here'"
}

@test "update with double quotes" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    picoDB --table "$BATS_TEST_NAME" --update '"Here," I said, "leave it to me."'
    assert_table_row "$BATS_TEST_NAME" \$ '"Here," I said, "leave it to me."'
}

@test "update with single and double quotes" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    picoDB --table "$BATS_TEST_NAME" --update "I muttered, \"I go with O'Brian.\""
    assert_table_row "$BATS_TEST_NAME" \$ "I muttered, \"I go with O'Brian.\""
}

@test "update with various special characters" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    picoDB --table "$BATS_TEST_NAME" --update '/the\ * is {a,b} for @me in ?!'
    assert_table_row "$BATS_TEST_NAME" \$ '/the\\ * is {a,b} for @me in ?!'
}

@test "update with everything" {
    initialize_table "$BATS_TEST_NAME" from one-entry

    picoDB --table "$BATS_TEST_NAME" --update "=		the what ?
\\	O'Brian has \"tons\" of stuff\!
**for** // but not here"
    assert_table_row "$BATS_TEST_NAME" \$ '=		the what ?\n\\	O'\''Brian has "tons" of stuff\\!\n**for** // but not here'
}
