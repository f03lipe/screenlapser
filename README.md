
This bash script lets you record screenlapses and save them with a background music.
It takes screenshots using scrot and then uses mencoder to compile it to an AVI film
with background music file specified by user.

It's yet just another excuse to learn Bash (Bourn Again SHell). :)

Requirements
------------

* [scrot](http://freecode.com/projects/scrot) - `apt-get install scrot`
* [mencoder](http://www.mplayerhq.hu/design7/news.html) - `apt-get install mencoder`

Usage
-----

	$ ./screenlapser.sh working_dir [ record | count | compile | restart ] [-m bgmusic]?

TODOs
-----

* Allow custom framerates in video (adjust to film duration).
* Allow for background music to be optional.
* Allow other formats, other than AVI.
* Create a directory by default, so the user doesn't have to.