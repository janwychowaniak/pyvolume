#!/bin/bash


# https://tex.stackexchange.com/questions/159459/how-to-make-labels-of-x-axis-texts-vertically-for-gnuplot
# https://stackoverflow.com/questions/13869439/gnuplot-how-to-increase-the-width-of-my-graph#13870144
# https://stackoverflow.com/questions/11092608/gnuplot-plotting-data-from-multiple-input-files-in-a-single-graph#answer-11092650


jak_uzywac() {
cat 1>&2 <<EOF

./`basename $0` [DATA_INPUT_1] [DATA_INPUT_2] [PLOT_OUTPUT]

	terminal png (gnuplot-nox)

EOF
}



if [ $# -ne 3 ]; then
	jak_uzywac
	exit 1
fi


DATAINPUT_1="$1"
DATAINPUT_2="$2"
PLOT_OUTPUT="$3"


echo "data input 1 = $DATAINPUT_1"
echo "data input 2 = $DATAINPUT_2"
echo "plot output  = $PLOT_OUTPUT"

echo "
set terminal png size 1000,480
set output \"$PLOT_OUTPUT\"
set xtics rotate
plot \"$DATAINPUT_1\" using 1:xtic(2) title \"$DATAINPUT_1\" with line, \"$DATAINPUT_2\" using 1:xtic(2) title \"$DATAINPUT_2\" with line
"| gnuplot -persist

