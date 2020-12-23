#!/usr/bin/env bats

load temp_database

@test "non-existing key deletion fails" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    run picoDB --table "$BATS_TEST_NAME" --delete notInHere
    [ $status -eq 4 ]
    [ "${#lines[@]}" -eq 0 ]
    updatedRowNum="$(get_row_number "$BATS_TEST_NAME")"; [ "$updatedRowNum" -eq "$rowNum" ]
}

@test "key can be deleted among many" {
    initialize_table "$BATS_TEST_NAME" from some-entries
    rowNum="$(get_row_number "$BATS_TEST_NAME")"

    run picoDB --table "$BATS_TEST_NAME" --delete Foo
    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 0 ]
    updatedRowNum="$(get_row_number "$BATS_TEST_NAME")"; [ "$updatedRowNum" -eq $((rowNum - 1)) ]
    assert_table_row "$BATS_TEST_NAME" 1 "foo"
    assert_table_row "$BATS_TEST_NAME" 2 "bar"
}

@test "existing single key can be deleted and removes the entire table" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 1 ]

    run picoDB --table "$BATS_TEST_NAME" --delete 'The Foo is 42'

    [ $status -eq 0 ]
    [ "${#lines[@]}" -eq 0 ]
    ! table_exists "$BATS_TEST_NAME"
}

@test "an empty delete key is deleted" {
    initialize_table "$BATS_TEST_NAME" from one-entry
    picoDB --table "$BATS_TEST_NAME" --update ""
    picoDB --table "$BATS_TEST_NAME" --update "last"

    run picoDB --table "$BATS_TEST_NAME" --delete ""
    [ $status -eq 0 ]
    [ "$(get_row_number "$BATS_TEST_NAME")" -eq 2 ]
    assert_table_row "$BATS_TEST_NAME" 1 "The Foo is 42"
    assert_table_row "$BATS_TEST_NAME" 2 "last"
}
