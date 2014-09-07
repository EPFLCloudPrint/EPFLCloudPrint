#!/bin/sh

lpstat -p mainprinters >> /dev/null 2>&1;
if [ $? -eq 0 ]; then
	echo The printer is installed;
	exit 0;
else
	echo Please run install.sh;
	exit 1;
fi;