#!/usr/bin/env bats

load temp_database

defineSpecialKeys()
{
    specialKeys=(
	'The Foo is 42'
	'x=y'
	'x-y'
	'x*y'
	'x y '
	$'x\n'
	'1more'
	'/'
	\\
	'???'
	'*'
	'[a-z]*'
	'{a,b}'
	/slashed\\
	$'multi\nline\n\ntext'
	$'\n'
	'tabbed	text'
	'"double-quoted"'
	"'single-quoted'"
	"mi\"x'd\"-quoted"
    )
}

setup()
{
    clean_table "$BATS_TEST_NAME"

    typeset -a specialKeys; defineSpecialKeys
    local key; for key in "${specialKeys[@]}"
    do
	picoDB --table "$BATS_TEST_NAME" --add "$key"
    done
}

@test "special character keys can be inserted and then obtained as dict" {
    run picoDB --table "$BATS_TEST_NAME" --get-as-dictionary myDict
    [ $status -eq 0 ]
    eval "$output"

    typeset -a specialKeys; defineSpecialKeys
    local key; for key in "${specialKeys[@]}"
    do
	[ "${myDict["$key"]}" = t ]
    done
}

contains()
{
    local elem needle=$1; shift
    for elem
    do
	[ "$needle" = "$elem" ] && return 0
    done
    return 1
}

@test "special character keys can be inserted and then obtained as escaped records" {
    readarray -t lines < <(picoDB --table "$BATS_TEST_NAME" --get-all)

    typeset -a specialKeys; defineSpecialKeys
    local line; for line in "${lines[@]}"
    do
	unescapedLine="$(echo -e "${line/#-/\x2d}X")"
	if ! contains "${unescapedLine%X}" "${specialKeys[@]}"; then
	    echo >&3 "missing: $unescapedLine"
	    return 1
	fi
    done
}
