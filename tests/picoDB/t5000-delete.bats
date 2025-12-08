#!/usr/bin/env bats

load fixture
load temp_database

@test "non-existing key deletion fails" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    run -4 picoDB --table "$BATS_TEST_NAME" --delete notInHere
    assert_equal ${#lines[@]} 0
    assert_row_count "$rowNum"
}

@test "key can be deleted among many" {
    initialize_table "$BATS_TEST_NAME" from some-entries
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    run -0 picoDB --table "$BATS_TEST_NAME" --delete Foo
    assert_equal ${#lines[@]} 0
    assert_row_count $((rowNum - 1))
    assert_table_row "$BATS_TEST_NAME" 1 "foo"
    assert_table_row "$BATS_TEST_NAME" 2 "bar"
}

@test "existing single key can be deleted and removes the entire table" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    assert_row_count 1

    run -0 picoDB --table "$BATS_TEST_NAME" --delete 'The Foo is 42'
    assert_equal ${#lines[@]} 0
    ! table_exists "$BATS_TEST_NAME"
}

@test "an empty delete key cannot be deleted by default" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    picoDB --table "$BATS_TEST_NAME" --allow-empty-key --update ""
    picoDB --table "$BATS_TEST_NAME" --update "last"

    run -2 picoDB --table "$BATS_TEST_NAME" --delete ""
    assert_output 'ERROR: Empty KEY not allowed.'
    assert_row_count 3
}

@test "an empty delete key is deleted with --allow-empty-key" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    picoDB --table "$BATS_TEST_NAME" --allow-empty-key --update ""
    picoDB --table "$BATS_TEST_NAME" --update "last"

    run -0 picoDB --table "$BATS_TEST_NAME" --allow-empty-key --delete ""
    assert_row_count 2
    assert_table_row "$BATS_TEST_NAME" 1 "The Foo is 42"
    assert_table_row "$BATS_TEST_NAME" 2 "last"
}
