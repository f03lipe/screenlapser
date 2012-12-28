
while getopts "ht:r:p:v" OPTION
do 
	case $OPTION in 
		h)
			echo "h"
			;;
		t)
			echo "t" $OPTARG
			;;
		p)
			echo "P" $OPTARG
			;;
		?)
			echo "Usage"
			;;
	esac
done
