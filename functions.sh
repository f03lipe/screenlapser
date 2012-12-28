#!/usr/bin/env bash
# functions.sh

## Helpers

function usage_and_die ()
{
	# print the usage message and quit
	echo -e "$USAGE"
	# attempt to return given argument
	exit ${1:-1}
}

function die ()
{
	echo >&2 "$@"
	exit ${2:-1}
}

function inform ()
{
	[[ $QUIET ]] || echo $@
}

## Actions

function stats ()
{
	# counts the number of frames already saved.
	frames=$(cat $LOGFILE | grep .jpg | wc -l)
	echo "Number of frames saved: $frames"
	return 0
}

function clean_dir ()
{
	echo "About to remove $(cat $LOGFILE | grep .jpg | wc -l) files."
	while :
	do
		read -p "Should we proceed? (y/N) " -n 1 -r choice
		echo
		case "$choice" in
			y|Y)
				break
				;;
			n|N)
				echo "Aborting."
				exit 0
				;;
			*)
				echo "Invalid option '$choice'. Aborting."
				exit 1
				;;
		esac
	done
	
	while read filename
	do
		rm $filename
	done < $LOGFILE

	> $LOGFILE

	inform "All files removed."
	inform "Logging file '$LOGFILE' cleared."
}

function record ()
{
	# Uses scrot to save screenshots to the current folder.
	# Changing the directory is a task for record's caller.
	# The sleep interval may be changed by setting $SLEEP.

	SLEEP=$(( SLEEP?SLEEP:1 ))

	inform "Saving screens to $PWD"
	inform "Sleep interval is set to ${SLEEP}s"

	nframes=0
	frames=$(cat $LOGFILE | grep .jpg | wc -l)
	tstart=$(date +"%s")
	
	inform "$frames previous frames were found."
	if [[ frames != "0" ]]
	then # There are pictures already saved.
		inform "Run script with option 'reset' to clear the files."
	fi

	SIGINT=2
	SIGQUIT=3

	# trap ^C signal to end loop
	trap "break;" $SIGINT $SIGQUIT
	while true
	do
		now=$(date +"%s")
		diff=$(($now-$tstart))
		frames=$(($frames+1))
		nframes=$(($nframes+1))
		fname="$(date +%Y%m%d%H%M%S).jpg"

		scrot -q 100 $fname
		inform "$frames frames saved. $(($diff / 60))min$(($diff % 60))s elapsed."
		echo $fname >> $LOGFILE
		sleep $SLEEP
	done

	echo -e "\nRecording stoped at `date +%T` with $frames frames ($nframes new)."
}

function compile ()
{
	# Compiles the screenshots using mencoder

	[ -f "$SOUNDTRACK" ] || die "music file $SOUNDTRACK doesn't exist. aborting."
	
	if [[ $(cat $LOGFILE 2>&- | grep .jpg | wc -l) == '0' ]]
	then
		die "No frames to compile. Aborting."
	fi
	
	if [[ -z $SOUNDTRACK ]]
	then
		inform "No soundtrack file was specified. Continuing..."
		if [[ $QUIET ]]
		then
			mencoder -ovc x264 -mf w=1400:h=900:fps=20:type=jpg 'mf://@'$LOGFILE -o $FINALFILE *>&-
		else
			mencoder -ovc x264 -mf w=1400:h=900:fps=20:type=jpg 'mf://@'$LOGFILE -o $FINALFILE
		fi
	else
		if [[ ! -f $SOUNDTRACK ]]
		then
			die "File '$SOUNDTRACK' doesn't exist. Aborting."
		else
			if [[ $QUIET ]]
			then
				mencoder -ovc x264 -oac mp3lame -audiofile "$SOUNDTRACK" \
						 -mf w=1400:h=900:fps=20:type=jpg 'mf://@'$LOGFILE -o $FINALFILE 2>&- 1>&-
			else
				mencoder -ovc x264 -oac mp3lame -audiofile "$SOUNDTRACK" \
						 -mf w=1400:h=900:fps=20:type=jpg 'mf://@'$LOGFILE -o $FINALFILE
			fi
		fi
	fi
	
	totem $FINALFILE
}
