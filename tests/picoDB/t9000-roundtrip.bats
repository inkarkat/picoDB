#!/usr/bin/env bats

load temp_database

setup()
{
    clean_table "$BATS_TEST_NAME"
}

@test "create a table with various keys, query them individually and in bulk" {
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
    empty=""

    picoDB --table "$BATS_TEST_NAME" --truncate --comment "Roundtrip table"
    picoDB --table "$BATS_TEST_NAME" --update "TABS=$tabs"
    picoDB --table "$BATS_TEST_NAME" --update "NEWLINES=$newlines"
    picoDB --table "$BATS_TEST_NAME" --update "QUOTED=$quoted"
    picoDB --table "$BATS_TEST_NAME" --update "SPECIALS=$specials"
    picoDB --table "$BATS_TEST_NAME" --update "NORMAL=$normal"
    picoDB --table "$BATS_TEST_NAME" --update "EMPTY=$empty"
    picoDB --table "$BATS_TEST_NAME" --update "SPACES=$spaces"

    eval "$(picoDB --table "$BATS_TEST_NAME" --get-all)"
    [ "$TABS" = "$tabs" ]
    [ "$NEWLINES" = "$newlines" ]
    [ "$QUOTED" = "$quoted" ]
    [ "$SPECIALS" = "$specials" ]
    [ "$NORMAL" = "$normal" ]
    [ "$EMPTY" = "$empty" ]
    [ "$SPACES" = "$spaces" ]


    [ "$tabs" = "$(picoDB --table "$BATS_TEST_NAME" --query TABS)" ]
    [ "$newlines" = "$(picoDB --table "$BATS_TEST_NAME" --query NEWLINES)" ]
    [ "$quoted" = "$(picoDB --table "$BATS_TEST_NAME" --query QUOTED)" ]
    [ "$specials" = "$(picoDB --table "$BATS_TEST_NAME" --query SPECIALS)" ]
    [ "$normal" = "$(picoDB --table "$BATS_TEST_NAME" --query NORMAL)" ]
    [ "$empty" = "$(picoDB --table "$BATS_TEST_NAME" --query EMPTY)" ]
    [ "$spaces" = "$(picoDB --table "$BATS_TEST_NAME" --query SPACES)" ]
}

@test "create, query, update, query, delete, query, drop" {
    text1="Some simple words"
    text2="Even simpler"
    text3="meaningless"

    picoDB --table "$BATS_TEST_NAME" --comment "Roundtrip table" --update "VALUE=$text1"
    picoDB --table "$BATS_TEST_NAME" --update "ALT=$text2"

    eval "$(picoDB --table "$BATS_TEST_NAME" --get VALUE)"
    [ "$VALUE" = "$text1" ]

    picoDB --table "$BATS_TEST_NAME" --update "VALUE=$text3"
    picoDB --table "$BATS_TEST_NAME" --delete ALT

    [ "$text3" = "$(picoDB --table "$BATS_TEST_NAME" --query VALUE)" ]

    picoDB --table "$BATS_TEST_NAME" --delete VALUE

    [ "" = "$(picoDB --table "$BATS_TEST_NAME" --query VALUE)" ]

    picoDB --table "$BATS_TEST_NAME" --drop

    run picoDB --table "$BATS_TEST_NAME" --query VALUE
    [ $status -eq 1 ]
}
