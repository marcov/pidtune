#!/bin/bash
set -euo pipefail

typeset -r respLabel="BT"
typeset -r stepLabel="Heater"
typeset -r outputDefault="step-response.txt"

################################################################################

if [ "$#" -lt 1 ]; then
	cat << EOF

$(basename $0) <INPUT FILE> [OUTPUT FILE]

Filters Artisan CSV data to extract step ($stepLabel) and response ($respLabel) columns.

EOF
	exit 1
fi

input="$1"
if [ "$#" -ge 2 ]; then
	output="$2"
else
	output="$outputDefault"
fi

# Detect column for $respLabel and $heaterLabel
fields=( $(sed '2q;d' $input) )

respOffset=
stepOffset=

ctr=1
for f in "${fields[@]}"; do
	case "$f" in
	"$respLabel")
		((respOffset=$ctr))
		;;
	"$stepLabel")
		((stepOffset=$ctr))
		;;
	esac
	[ -n "$stepOffset" ] && [ -n "$respOffset" ] && break
	((ctr+=1))
done

[ -z "$stepOffset" ] || [ -z "$respOffset" ] && { echo "ERROR: could not find $stepLabel and/or $respLabel columns in $input."; exit -1; }

echo "INFO: found step ($stepLabel) at column $stepOffset and response($respLabel) at column $respOffset"

sed '1d;2d' "$input" | sed "s/\t/,/g" | awk -v STEP=$stepOffset -v RESP=$respOffset '
begin
	{FS=","}
	{
		if ($STEP != "" && $RESP != "")
			print $STEP" "$RESP
	}
end
' > "$output"

echo "INFO: file $output generated successfully."
