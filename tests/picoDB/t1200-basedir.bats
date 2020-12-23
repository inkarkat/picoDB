#!/usr/bin/env bats

@test "custom base dir can be passed" {
    run picoDB --basedir "${BATS_TEST_DIRNAME}/databases" --table one-entry --query 'The Foo is 42'
    [ $status -eq 0 ]
    [ "$output" = "" ]
}

@test "a non-existing base dir is created" {
    local newDir="${BATS_TMPDIR}/new"
    rm -rf "$newDir"
    run picoDB --basedir "$newDir" --table "$BATS_TEST_NAME" --update "newkey"
    [ $status -eq 0 ]
    [ -f "${newDir}/$BATS_TEST_NAME" ]
    rm -rf "$newDir"
}
