#!/usr/bin/env bash
# record.sh

# mencoder compilation snippet taken from
# http://www.bhalash.com/archives/885403473
# I did the rest.

NAME="screenlapser"
VERSION="1.0"
AUTHOR="@f03lipe"
USAGE="Usage: $(basename $0) [-d dir] [-m soundtrack] [-q] [ action ]
Create and compile screenlapses using scrot and mencoder.
where:
	action is among:
		record		Starts taking pictures.
		compile		Uses mencoder to create the video.
		reset		Removes the saved screenshots from the directory specified.
		stats		Shows stats on the number of screenshoots taken.
	-d	Specifies the directory to save the screenshots.
	-m	Specifies the background music for the footage.
		Only used when the action is set to 'compile'.
	-q	Quiet mode.
Attention: please, follow the order specified above."

unset QUIET # Just to make sure.
LOGFILE=".screens"
FINALFILE="$SOURCE_DIR/screenlapse.avi"
SOURCE_DIR=`dirname $0`

source $SOURCE_DIR/functions.sh

# Globals in this script.
#	SOUNDTRACK		# The soundtrack file to the video. 
#	LOGFILE			# Keeps track of the screenshot files.
#	FINALFILE		# The destination of the video
#	WORKING_DIR		# 
#	SOURCE_DIR		# 
#	SOUNDTRACK		# Music background for the video
#	SLEEP			# 
#	QUIET			# Quiet mode is on when this is set.



#! add -:
# see http://stackoverflow.com/questions/402377/7680682#7680682

E_BADARGS=85
E_NOTFOUND=86

while getopts ":m:d:q" OPTION
do
	case $OPTION in
		d)
			WORKING_DIR="$OPTARG"
			;;
		m)
			SOUNDTRACK="$OPTARG"
			;;
		q)
			QUIET=1
			;;
		:) # smile
			echo "Option -$OPTARG requires an argument." >&2
			usage_and_die $E_BADARGS
			;;

		?)
			echo "Unknown option -$OPTARG." >&2
			usage_and_die $E_BADARGS
			;;
	esac
done

# Try to cd to $WORKING_DIR.
if [[ -z $WORKING_DIR ]]
then
	echo "Working directory not specified." >&2
	usage_and_die $E_BADARGS
elif [[ ! -d $WORKING_DIR ]]
then
	die "$WORKING_DIR: not a valid directory." $E_NOTFOUND
fi

cd $WORKING_DIR
inform "Working inside '$WORKING_DIR'"
#


if [[ ! -f $LOGFILE ]]
then
	touch $LOGFILE
	echo "Creating trackfile at $LOGFILE"
fi

for var in "$@"
do
	case $var in
		"record") # Enter screenshots loop.
			record
			exit 0
			;;

		"stats") # Show status for pics taken.
			stats
			exit 0
			;;

		"compile") # Compile pictures into video.
			compile
			exit 0
			;;
		
		"reset") # Clean up all pictures and record.
			clean_dir
			record
			exit 0
			;;
	esac
done

die "Not a valid action specified. Choose [ record | stats | compile | reset ]." >&2
