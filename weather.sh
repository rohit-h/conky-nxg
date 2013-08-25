#!/bin/bash



WeatherCache="$HOME/.conky/conky-nxg/weather.xml"
WeatherURL="http://weather.yahooapis.com/forecastrss?w=29222422&u=c"



if [ "$1" = "-u" ]; then
	if ping -c 2 google.com 1>/dev/null ; then
		echo 'updating...'
		wget -qO "$WeatherCache" "$WeatherURL"
	fi
	exit 0
fi

if [ ! -e "$WeatherCache" ]; then
	echo "Weather XML not found. Try running $0 -u"
	exit 0
fi

LOCATION=`grep title "$WeatherCache" | head -n 1 | cut -d '-' -f 2 | cut -d '<' -f 1`

TODAY=`grep yweather:condition "$WeatherCache"`
LATER=`grep yweather:forecast "$WeatherCache" | sed -n '1p'`
TOMOR=`grep yweather:forecast "$WeatherCache" | sed -n '2p'`
DAYAF=`grep yweather:forecast "$WeatherCache" | sed -n '3p'`

function getCode {
	STRING="$@"
	echo "$STRING" | cut -d '"' -f 12
}

function getTemps {
	STRING="$@"
	LOW=`echo "$STRING" | cut -d '"' -f 6`
	HIGH=`echo "$STRING"| cut -d '"' -f 8`
	echo "$LOW | $HIGH"
}

PIC0=`echo "$TODAY" | cut -d '"' -f 6`
PIC1=`getCode $LATER`
PIC2=`getCode $TOMOR`
PIC3=`getCode $DAYAF`

TMP0=`echo "$TODAY" | cut -d '"' -f 4`
TMP1=`getTemps $LATER`
TMP2=`getTemps $TOMOR`
TMP3=`getTemps $DAYAF`

echo -n '${offset 975}${font Open Sans Light:size=16}weather${font Open Sans:size=8}${offset 60}${voffset -8}NOW${offset 40}LATER${offset 45}TOM${offset 35}DAY AFT${offset -350}${voffset 20}'$LOCATION
echo '${image ~/.weathericons/'$PIC0'.png -s 32x32 -p 1110,55}${image ~/.weathericons/'$PIC1'.png -s 32x32 -p 1180,55}${image ~/.weathericons/'$PIC2'.png -s 32x32 -p 1250,55}${image ~/.weathericons/'$PIC3'.png -s 32x32 -p 1320,55}'
echo -n "\${voffset 20}\${offset 1115}$TMP0 C\${offset 40}$TMP1\${offset 33}$TMP2\${offset 33}$TMP3"

