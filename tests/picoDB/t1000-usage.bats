#!/usr/bin/env bats

load fixture
load usage

@test "no arguments prints message and usage instructions" {
    run -2 picoDB
    assert_line -n 0 "ERROR: No action passed: $ACTIONS"
    assert_line -n 2 -e '^Usage:'
}

@test "invalid option prints message and usage instructions" {
    run -2 picoDB --invalid-option
    assert_line -n 0 'ERROR: Unknown option "--invalid-option"!'
    assert_line -n 2 -e '^Usage:'
}

@test "-h prints long usage help" {
    run -0 picoDB -h
    refute_line -n 0 -e '^Usage:'
}

@test "additional arguments print short help" {
    run -2 picoDB --table some-entries --query foo whatIsMore
    assert_line -n 0 'ERROR: Additional argument "whatIsMore".'
    assert_line -n 2 -e '^Usage:'
}

@test "no action prints message and usage instructions" {
    run -2 picoDB --table some-entries
    assert_line -n 0 "ERROR: No action passed: $ACTIONS"
    assert_line -n 2 -e '^Usage:'
}
