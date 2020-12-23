#!/bin/bash

export ACTIONS='--add / --update, --delete, --truncate, --drop, --exists / --query, --get-all, --get-as-dictionary'
assert_multiple_actions_error()
{
    [ "${lines[0]}" = "ERROR: Only one of $ACTIONS allowed." ]
}
