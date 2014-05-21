#!/bin/sh

if test $# -lt 3; then
  echo "Missing arguments" 2>&1;
  exit -1;
fi

login="$1"; shift
password="$1"; shift
file="$1"; shift
options="$@";

printer="Pool1-$login-$RANDOM";

lpadmin -p $printer -E -v smb://$login:$password@print1.epfl.ch/pool1 -P /usr/share/cups/model/xr_WorkCentre7655R.ppd 2>&1
lp -d $printer $file $options

sleep 2

// lpadmin -x $printer
rm -f "$file"
