#!/bin/bash
SCRIPTDIR=$(cd $(dirname $0) && pwd)
function makeRockspec() {
	dir=$1
	rock=$2
	(
		cd $SCRIPTDIR && cd $dir && echo "Building rock $rock in $(pwd)" && luarocks make $rock
	)
}

makeRockspec lua-feedparser && \
	makeRockspec .
