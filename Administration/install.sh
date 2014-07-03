#!/bin/sh
if [ $(uname) = "Linux" ]; then
	echo "Linux configuaration detected";
	extension=".gz";
else
	if [ $(uname) = "Darwin" ]; then
		echo "Mac OS configuaration detected";
		extension="";
	else
		echo "Unknow Operation System" >&2;
		exit 1;
	fi
fi

echo "create directory CloudPrintUpload for uploading files in /tmp";
dir="/tmp/CloudPrintUpload";
if [ -e $dir ]
	then
	rm -rf $dir;
fi
#Create a folder that everybody can write in
mkdir -m o+wr $dir;

echo "Locating PPD";
ppd="/usr/share/cups/model/xr_WorkCentre7655R.ppd$extension";
mac_ppd=/Library/Printers/PPDs/Contents/Resources/Xerox\ WorkCentre\ 7655.gz;
if [ ! -e "$ppd" ]; then
	if [ $(uname) = "Darwin" ] && [ -e "$mac_ppd" ]; then
		mv "$mac_ppd" "$ppd";
	else
		echo "downloading it from EPFL server";
		wget http://linux.epfl.ch/webdav/site/linuxline/shared/xr_WorkCentre7655R.ppd.gz -P /usr/share/cups/model;
		if [ $(uname) = "Darwin" ]; then
			gunzip /usr/share/cups/model/xr_WorkCentre7655R.ppd.gz /usr/share/cups/model/;
		fi
	fi
fi
if [ -f "$ppd" ] && [ -d "$dir" ]; then
	echo "Adding a printer named mainPrinter";
	lpadmin -x mainPrinter;
	lpadmin -p mainPrinter -E -v lpd://print1.epfl.ch/pool1 -P "$ppd";
else
	echo "Failed to move printer, please use `sudo`" >&2;
	exit 1;
fi
