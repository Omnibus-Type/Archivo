#!/bin/sh
#
# This script is going to convert the binary fonts in TTX fonts
#
# Dependencies:
#	
#	TTX/FontTools
#	https://github.com/behdad/fonttools.git
#
# Positioning the current directory in the directory where is the script located
cd "$(dirname "$0")"
font2ttx() {
	if [ -e "$1" ] ; then
		prefix="${1%/*}"/"${1##*.}"/
		fileName="${1##*/}"
		dirName="${fileName%%.*}"
		outputDir="${prefix}${dirName}"
		if [ ! -d "$outputDir" ] ; then
			mkdir -p "$outputDir" ;
		fi
		ttx -s -d "$outputDir" $1
	else
		printf "$1 doesn't exist"
		exit 1
	fi
}
# Go to the otf directory and convert the binary fonts to ttx XML
for font in ../fonts/*.{o,t}tf ; do
	echo "converting ${font##*/}"
	font2ttx "$font"
	rm "$font"
done
exit 0