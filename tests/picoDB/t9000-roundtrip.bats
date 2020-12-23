#!/usr/bin/env bats

load temp_database
load array_operations

defineKeys()
{
    tabs="this	has	tab	characters"
    newlines="here
the
text
  goes
    over
      several
        lines"
    quoted="I'd rather say: \"How dare you?\""
    specials='* for {here, there} // no matter \\ ?'
    normal="Just plain text"
    spaces="  "

    keys=(
	"$tabs"
	"$newlines"
	"$quoted"
	"$specials"
	"$normal"
	"$spaces"
    )
}
setup()
{
    clean_table "$BATS_TEST_NAME"
}

@test "create a table with various keys, query them individually, in bulk as lines, in bulk via dict" {
    picoDB --table "$BATS_TEST_NAME" --truncate

    typeset -a keys; defineKeys
    local key; for key in "${keys[@]}"
    do
	picoDB --table "$BATS_TEST_NAME" --add "$key"
    done

    for key in "${keys[@]}"
    do
	picoDB --table "$BATS_TEST_NAME" --exists "$key"
    done

    readarray -t lines < <(picoDB --table "$BATS_TEST_NAME" --get-all)

    local line; for line in "${lines[@]}"
    do
	unescapedLine="$(echo -e "${line/#-/\x2d}X")"
	if ! contains "${unescapedLine%X}" "${keys[@]}"; then
	    echo >&3 "missing: $unescapedLine"
	    return 1
	fi
    done

    run picoDB --table "$BATS_TEST_NAME" --get-as-dictionary myDict
    [ $status -eq 0 ]
    eval "$output"

    local key; for key in "${keys[@]}"
    do
	[ "${myDict["$key"]}" = t ]
    done
}

@test "create, query, update, query, delete, query, drop" {
    text1="Some simple words"
    text2="Even simpler"
    text3="meaningless"

    picoDB --table "$BATS_TEST_NAME" --update "$text1"
    picoDB --table "$BATS_TEST_NAME" --update "$text2"

    eval "$(PICODB_DICT_VALUE=1 picoDB --table "$BATS_TEST_NAME" --get-as-dictionary values)"
    [ "${values["$text1"]}" = 1 ]
    [ "${values["$text2"]}" = 1 ]
    [ -z "${values["$text3"]}" ]

    picoDB --table "$BATS_TEST_NAME" --update "$text3"
    picoDB --table "$BATS_TEST_NAME" --delete "$text2"

    picoDB --table "$BATS_TEST_NAME" --query "$text1"
    ! picoDB --table "$BATS_TEST_NAME" --query "$text2"
    picoDB --table "$BATS_TEST_NAME" --query "$text3"

    picoDB --table "$BATS_TEST_NAME" --delete "$text1"

    ! picoDB --table "$BATS_TEST_NAME" --query "$text1"
    ! picoDB --table "$BATS_TEST_NAME" --query "$text2"
    picoDB --table "$BATS_TEST_NAME" --query "$text3"

    picoDB --table "$BATS_TEST_NAME" --drop

    run picoDB --table "$BATS_TEST_NAME" --query "$text1"
    [ $status -eq 1 ]
}
