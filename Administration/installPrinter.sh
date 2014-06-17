#!/usr/bin/sh
echo "Adding a printer named mainPrinter\n";

lpadmin -p mainPrinter -E -v lpd://print1.epfl.ch/pool1 -P /usr/share/cups/model/xr_WorkCentre7655R.ppd.gz

echo "printer created\n";
