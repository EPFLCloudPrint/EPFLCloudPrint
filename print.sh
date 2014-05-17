#!/bin/sh
# /!\ files don't start with a '-'
# No space in names and passwords
# input : login, password, files, -o options

if test $# -lt 3; then
  echo "Missing arguments" 2>&1;
  exit -1;
fi

login=$1; shift
password=$1; shift
file="$1"; shift
myOptions="$1";
options="$@";

echo "user : " $login 
echo "file : " $file
echo "options : " $options;
printer="Pool1-$login-$RANDOM";


lpadmin -p $printer -E -v smb://INTRANET/$login:$password@print1.epfl.ch/pool1 -P /usr/share/cups/model/xr_WorkCentre7655R.ppd.gz 2>&1
#echo "lpadmin -p $printer -E -v smb://INTRANET/$login:$password@print1.epfl.ch/pool1 -P /usr/share/cups/model/xr_WorkCentre7655R.ppd.gz"

  echo "lp -d $printer $file $options"
  lp -d $printer $file $options

sleep 2

lpadmin -x $printer
