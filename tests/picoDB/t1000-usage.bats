#!/usr/bin/env bats

load usage

@test "no arguments prints message and usage instructions" {
    run picoDB
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No action passed: $ACTIONS" ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "invalid option prints message and usage instructions" {
    run picoDB --invalid-option
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Unknown option "--invalid-option"!' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "-h prints long usage help" {
    run picoDB -h
    [ $status -eq 0 ]
    [ "${lines[0]%% *}" != 'Usage:' ]
}

@test "additional arguments print short help" {
    run picoDB --table some-entries --query foo whatIsMore
    [ $status -eq 2 ]
    [ "${lines[0]}" = 'ERROR: Additional argument "whatIsMore".' ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}

@test "no action prints message and usage instructions" {
    run picoDB --table some-entries
    [ $status -eq 2 ]
    [ "${lines[0]}" = "ERROR: No action passed: $ACTIONS" ]
    [ "${lines[2]%% *}" = 'Usage:' ]
}
