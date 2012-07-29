#!/usr/bin/env bash
# functions.sh

function usage_and_exit ()
{
	# print the usage message and quit
	echo -e "$USAGE"
	# attempt to return given argument
	exit $1 || 1
}

function die ()
{
	echo >&2 "$@";
	exit 1
}

function stats ()
{
	# counts the number of frames already saved.

	frames=$(ls *.jpg 2> /dev/null | wc -l);
	echo "ammount of frames saved: $frames"
	return 0
}

function record ()
{
	# uses scrot to save frames to the actual folder
	# the change-directory job must be done by the caller
	# the sleep interval may be set in the $SLEEP variable.

	SLEEP=$(( SLEEP?SLEEP:1 ))

	echo "saving pictures to $PWD"
	echo "sleep interval set to $SLEEP"

	frames=0
	started=$(date +"%s")
	
	if [ $(ls *.jpg 2> /dev/null | wc -l) != 0 ]
	then
		# if any frames are already saved, add them to the count
		frames=$(( $(ls *.jpg | wc -l) ))
		echo "$frames frames were found. updating the count"
	fi

	SIGINT=2
	SIGQUIT=3

	# trap ^C signal to end loop
	trap "break;" 2 3

	while true
	do
		now=$(date +"%s")
		diff=$(($now-$started))
		frames=$(($frames+1))

		scrot -q 100 $(date +%Y%m%d%H%M%S).jpg 
		echo "$frames frames saved. $(($diff / 60))min$(($diff % 60))s elapsed."

		sleep $SLEEP
	done

	echo -e "\nrecording stoped at `date +%T` with $frames frames."

	return 0
}

function compile ()
{
	# compiles the screenshots into a screenlapse.avi video

	[ -f "$MUSIC_BG" ] || die "music file $MUSIC_BG doesn't exist. aborting."
	[ $(ls *.jpg 2> /dev/null | wc -l) != 0 ] || die "there are no frames to compile. aborting."

	# make file list
	ls -1tr *.jpg > files.txt
	
	mencoder -ovc x264 -oac mp3lame -audiofile "$music" -mf w=1400:h=900:fps=20:type=jpg 'mf://@files.txt' -o screenlapse.avi
	totem screenlapse.avi
	rm files.txt

	return 0
}