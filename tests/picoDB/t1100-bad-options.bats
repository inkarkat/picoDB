#!/usr/bin/env bats

load fixture
load usage

@test "multiple actions print usage error" {
    run -2 picoDB --table some-entries --query foo --update "fox=bar"
    assert_multiple_actions_error
    assert_line -n 2 -e '^Usage:'
}

@test "invalid base-type prints usage error" {
    run -2 picoDB --base-type doesNotExist --table whatever --query foo
    assert_line -n 0 'ERROR: Invalid base-type "doesNotExist".'
    assert_line -n 2 -e '^Usage:'
}

@test "invalid table with slash prints usage error" {
    run -2 picoDB --table not/allowed --query foo
    assert_line -n 0 'ERROR: TABLE must not contain slashes.'
    assert_line -n 2 -e '^Usage:'
}

@test "empty dict-name prints usage error" {
    run -2 picoDB --table whatever --get-as-dictionary ''
    assert_line -n 0 'ERROR: Need DICT-NAME.'
    assert_line -n 2 -e '^Usage:'
}
