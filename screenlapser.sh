#!/usr/bin/env bash
# record.sh

# mencoder compilation snippet taken from
# http://www.bhalash.com/archives/885403473
# I did the rest.

NAME="screenlapser"
VERSION="1.0"
AUTHOR="@f03lipe"
USAGE="Usage: screenlapser.sh working_dir [ record | stats | compile | restart ] [-m music-file]?"

E_BADARGS=85
E_NOTFOUND=86

source functions.sh

# second arg must be a valid dir
[ -d $1 ] || die "$1 isn't a valid directory. aborting."

cd $1

case $2 in
	"record")
			record;;
	
	"stats")
			stats;;
	
	"compile")
			[ -n "$3" ] || die "'compile' option with no bg music file defined."
			shift 2

			while getopts "m:" a
			do 
				MUSIC_BG="$OPTARG"
			done
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