#!/usr/bin/env bash
# record.sh

# mencoder compilation snippet taken from
# http://www.bhalash.com/archives/885403473
# I did the rest.


source functions.sh

NAME="screenlapser"
VERSION="1.0"
AUTHOR="@f03lipe"
USAGE="Usage: screenlapser.sh [ record | count | compile | restart ] dir (? music-file)"
# SLEEP=

[[ "$#" == 2 || "$#" == 3 ]] || {
	echo "invalid number of arguments entered. aborting."
	usage_and_exit
}

# second arg must be a valid dir
[ -d $2 ] || die "entered directory doesn't exist. aborting."

cd $2

case $1 in
	
	"record")
			record
			;;
	
	"stats")
			stats
			;;
	
	"compile")
			[ -n "$3" ] || die "'compile' option with no bg music file defined."
			MUSIC_BG="$3"
			compile
			;;
	
	"restart")
			rm *.jpg
			record
			;;
	
	*)
			echo "option '$1' not recognized."
			usage_and_exit
			;;
esac

exit 0