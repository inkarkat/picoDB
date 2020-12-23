#!/usr/bin/env bats

load canned_databases

@test "empty key can be queried" {
    picoDB --table special --query ''
}

@test "key with = in it can be queried" {
    picoDB --table special --query 'x=y'
}

@test "key starting with 1 can be queried" {
    picoDB --table special --query '1more'
}

@test "key with - in it can be queried" {
    picoDB --table special --query 'x-y'
}

@test "key with * in it can be queried" {
    picoDB --table special --query 'x*y'
}

@test "key with spaces in it can be queried" {
    picoDB --table special --query 'x y '
}

@test "key with newline in it can be queried" {
    picoDB --table special --query $'x\n'
}

@test "slash key can be queried" {
    picoDB --table special --query '/'
}

@test "backslash key can be queried" {
    picoDB --table special --query '\'
}

@test "no double backslash key is there" {
    run picoDB --table special --query '\\'
    [ $status -eq 4 ]
}

@test "key with slashes can be queried" {
    picoDB --table special --query '/slashed\'
}

@test "multi-line key can be queried" {
    picoDB --table special --query "multi
line

text"
}

@test "key with tab in it can be queried" {
    picoDB --table special --query "tabbed	text"
}

@test "newline key can be queried" {
    picoDB --table special --query $'\n'
}

@test "no double newline key is there" {
    run picoDB --table special --query $'\n\n'
    [ $status -eq 4 ]
}

@test "double-quoted key can be queried" {
    picoDB --table special --query '"double-quoted"'
}

@test "single-quoted key can be queried" {
    picoDB --table special --query "'single-quoted'"
}

@test "mixed-quoted key can be queried" {
    picoDB --table special --query "mi\"x'd\"-quoted"
}
