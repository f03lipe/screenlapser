
This bash script lets you record screenlapses and save them with a background music.
It takes screenshots using scrot and then uses mencoder to compile it to an AVI film
with background music file specified by user.

It's yet just another excuse to learn Bash. :)

Requirements
------------

* [scrot](http://freecode.com/projects/scrot) - `apt-get install scrot`
* [mencoder](http://www.mplayerhq.hu/design7/news.html) - `apt-get install mencoder`

Usage
-----

	Usage: $ ./screenlapser.sh [-d dir] [-m soundtrack] [-q] [ action ]
	Create and compile screenlapses using scrot and mencoder.
	where:
		action is among:
			record      Starts taking pictures.
			compile     Uses mencoder to create the video.
			reset       Removes the saved screenshots from the directory specified.
			stats       Shows stats on the number of screenshoots taken.
		-d  Specifies the directory to save the screenshots.
		-m  Specifies the background music for the footage.
			Only used when the action is set to 'compile'.
		-q  Quiet mode.
	Attention: please, follow the order specified above.

TODOs
-----
* Allow other formats, other than AVI.
* Custom fps. (based on soundtrack length?)
* Let user set the final filename.
