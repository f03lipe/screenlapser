
This bash script lets you record screenlapses and save them with a background music.
by taking screenshots from time to
time and compiling them into an .avi video, with background music.

Yet another excuse to learn Bash (Bourn Again SHell). :)

---

### Requirements
* [scrot](http://freecode.com/projects/scrot) - `apt-get install scrot`
* [mencoder](http://www.mplayerhq.hu/design7/news.html) - `apt-get install mencoder`

---

### Usage:
	
	$ ./screenlapser.sh working_dir [ record | count | compile | restart ] [-m bgmusic]?

---

### Next TODOs:

* allow custom framerate
* optional background music
* allow other codecs