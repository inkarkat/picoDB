#!/usr/bin/env bats

load canned_databases

@test "existing records for two tables can be gotten into the same dict" {
    eval "$(picoDB --table one-entry --get-as-dictionary myDict)"
    [ ${#myDict[@]} -eq 1 ]
    [ "${myDict['The Foo is 42']}" = t ]

    eval "$(picoDB --table some-entries --get-as-dictionary myDict)"
    [ ${#myDict[@]} -eq 6 ]
    [ "${myDict['The Foo is 42']}" = t ]
    [ "${myDict['foo']}" = t ]
    [ "${myDict['baz']}" = t ]

    eval "$(PICODB_DICT_VALUE=abc picoDB --table one-entry --get-as-dictionary myDict)"
    [ ${#myDict[@]} -eq 6 ]
    [ "${myDict['The Foo is 42']}" = abc ]
    [ "${myDict['foo']}" = t ]
}

@test "clearing the dict between queries" {
    eval "$(picoDB --table one-entry --get-as-dictionary myDict)"
    [ ${#myDict[@]} -eq 1 ]
    [ "${myDict['The Foo is 42']}" = t ]

    myDict=()
    eval "$(picoDB --table some-entries --get-as-dictionary myDict)"
    [ ${#myDict[@]} -eq 5 ]
    [ -z "${myDict['The Foo is 42']}" ]
    [ "${myDict['foo']}" = t ]
    [ "${myDict['baz']}" = t ]
}
