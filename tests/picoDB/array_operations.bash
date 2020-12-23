#!/bin/bash

contains()
{
    local elem needle=$1; shift
    for elem
    do
	[ "$needle" = "$elem" ] && return 0
    done
    return 1
}
