#!/bin/sh

cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

$cli set repeat.wait 0
/bin/echo -n .
$cli set repeat.initial_wait 300
/bin/echo -n .
$cli set remap.hjkl_arrow 1
/bin/echo -n .
$cli set remap.hjkl_arrow_xcode 1
/bin/echo -n .
/bin/echo
