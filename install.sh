#!/bin/bash

#############################################
# Conky-NXG quick n dirty installer script
#############################################

# Installation paths. Paths are hardcoded in config files.
# Do not change them here unless you have update it there

ConkyBase="$HOME/.conky"
ConkyConf="$ConkyBase/conky-nxg"

# Data files

Files="conkyrc desktop.lua README.md date.sh weather.sh back.png"
Dir="weathericons"

echo -n "
 ========================
  Conky-NXG installation
 ========================

 Config will be installed in $ConkyConf

 Continue? [Y/n] : "

read confirm

if [ "$confirm" = "n" -o "$confirm" = "N" ]; then
	exit 0
	echo "Aborted"
fi

echo " >> Installing ... "

# Obtain a clean directory to copy to

if [ -f "$ConkyBase" ]; then
	echo "A file called $ConkyBase exists"
	echo "Delete it manually and re-run this script"
	exit 1
fi

if [ ! -e "$ConkyBase" ]; then
	mkdir -v "$ConkyBase"
fi

if [ ! -w "$ConkyBase" ]; then
	echo "The directory $ConkyBase is not writable. Cannot continue"
	exit 2
fi

if [ -d "$ConkyConf" ]; then
	echo -n "This setup is already installed. Re-install? [y/N] : "
	read confirm
	if [ "$confirm" != "y" -a "$confirm" != "Y" ]; then
		echo "Aborting"
		exit 4
	fi
else
	mkdir -pv "$ConkyConf"
fi


#############################################
# Copy config files and scripts

echo " >> Copying files"
for target in $Files; do
	echo $target
	cp "$target" "$ConkyConf/"
done

echo " >> Copying weather icon pack"
cp -rf weathericons "$ConkyConf/"

chmod a+x "$ConkyConf"/*.sh

echo " !! To change weather location, update the URL variable in weather.sh"
echo " >> Running weather update script"
echo "    $ConkyConf/weather.sh -u"
$ConkyConf/weather.sh -u

# Activate config

echo
echo -n "Activate this config now? [y/N] : "
read confirm

if [ "$confirm" = "y" -o "$confirm" = "Y" ]; then

	if [ -e "$HOME/.conkyrc" ]; then
		echo " Default conky config file found. Backing it up"
		mv "$HOME/.conkyrc" "$HOME/.conkyrc.old"
	fi
	ln -s "$ConkyConf/conkyrc" "$HOME/.conkyrc"
	sleep 1
	echo "Starting conky. Errors logged at $HOME/.conkylog"
	conky &> $HOME/.conkylog &
fi

echo " >> Installation complete"
echo " !! Run the weather.sh script with -u flag to fetch weather data"

exit 0
