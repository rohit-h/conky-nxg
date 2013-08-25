#!/bin/bash

#############################################
# Conky-NXG quick n dirty (un)installer script
#############################################

ConkyBase="$HOME/.conky"
ConkyConf="$ConkyBase/conky-nxg"

ConkyRC="~/.conkyrc"

echo -n "
 ========================
  Conky-NXG uninstallation
 ========================

 Will delete this config and restore previous conky config.

 Continue? [Y/n] : "

read confirm

if [ "$confirm" = "n" -o "$confirm" = "N" ]; then
	exit 0
	echo "Aborted"
fi

echo " >> Uninstalling ... "

rm "$ConkyRC" 2> /dev/null
rm -rf "$ConkyConf" 2> /dev/null
[ -e "$ConkyRC".old ] && mv -v "$ConkyRC".old "$ConkyRC"
