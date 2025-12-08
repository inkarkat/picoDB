#!/usr/bin/env bats

load fixture

@test "custom base dir can be passed" {
    run -0 picoDB --basedir "${BATS_TEST_DIRNAME}/databases" --table one-entry --query 'The Foo is 42'
    assert_output ''
}

@test "a non-existing base dir is created" {
    local newDir="${BATS_TMPDIR}/new"
    rm -rf -- "$newDir"
    run -0 picoDB --basedir "$newDir" --table "$BATS_TEST_NAME" --update "newkey"
    assert_file_exists "${newDir}/$BATS_TEST_NAME"
    rm -rf -- "$newDir"
}
