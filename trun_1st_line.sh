#!/bin/bash


# https://askubuntu.com/questions/410196/remove-first-n-lines-of-a-large-text-file


jak_uzywac() {
cat 1>&2 <<EOF

./`basename $0` [INPUT]

	In place!

EOF
}



if [ $# -ne 1 ]; then
	jak_uzywac
	exit 1
fi


INPUT="$1"
sed -i 1,1d $INPUT
