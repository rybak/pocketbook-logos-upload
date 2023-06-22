#!/usr/bin/env bash

# Convert any images to the BMP format compatible with Pocketbook 611 and
# similar models.
#
# Usage:
#     ./pocketbook-convert.sh *.jpg *.png
#
# See also https://superuser.com/a/1778509/133421

if [[ $# -lt 1 ]]
then
	echo "Specify filename"
	exit 1
fi

while [[ $# -gt 0 ]]
do
	from="$1"
	to="${1%.*}.bmp"
	shift
	echo "'$from' -> '$to'"

	# Prefix BMP3: is needed to specify version of BMP format:
	#   https://imagemagick.org/script/formats.php#supported
	# because by default regular BMP is used, which is BMP version 4.
	# See also list of formats via `identify -list format`
	#
	# Documentation of CLI options:
	#   https://imagemagick.org/script/command-line-options.php
	convert "$from" -type Grayscale -colorspace Gray -colors 255 -compress None BMP3:"$to"

	# I figured out the exact parameters for other options by comparing
	# output of `identify -verbose` between a supported file and an
	# unsupported file.
	# Also, this answer <https://unix.stackexchange.com/a/382758/53143>
	# about `DirectClass` and PseudoClass helped understand what's going on
	# with color maps and color spaces.
done
