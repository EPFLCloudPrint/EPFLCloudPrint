#!/bin/sh
# /!\ files don't start with a '-'
# No space in names and passwords
# input : login, password, files, -o options

if test $# -lt 3; then
  echo "Missing arguments" 2>&1;
  exit -1;
fi

echo "salut user : $USER";
login=$1; shift
password=$1; shift

i=0
while test "$1" -a ! `echo "$1" | grep -e "^-.$"`; do
  files="$1"; shift
  
done
echo "charles"
printer="Pool1-$login-$RANDOM";
lpadmin -p $printer -E -v smb://INTRANET/$login:$password@print1.epfl.ch/pool1 -P /usr/share/cups/model/xr_WorkCentre7655R.ppd.gz 2>&1
echo "lpadmin -p $printer -E -v smb://INTRANET/$login:$password@print1.epfl.ch/pool1 -P /usr/share/cups/model/xr_WorkCentre7655R.ppd.gz"

  echo "lp -d $printer $files"
  lp -d $printer "$files"

sleep 2

lpadmin -x $printer
