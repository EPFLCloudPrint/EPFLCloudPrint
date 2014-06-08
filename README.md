# EPFLCloudPrint

## Overview

*EPFLCloudPrint* is a simple web service to bring remote printing to handheld devices.
This project was created to be able to send files to EPFL's printing pool from mobile phones and tablets. It is also an alternative way to print from your computer without having to install the printer's driver.
Its uses aren't limited to our university but can be ported to any company or university server, so users can print from any browser.

## Apache Server configuration

- enable php on the server : uncomment `LoadModule php5...` line in configuration file `/etc/apache2/httpd.conf`,
- fix the `upload_max_filesize` option in `/etc/php.ini`,
- fix the rights for `uploads/` : `chown _www uploads/` or `chown var_www uploads/`
- give rights to amin the printers to the web server user : `sudo dseditgroup -o edit -a _www -t user admin` for OS X,
- change CUPS configuration (on `localhost:631/admin`) and toggle "Use Kerberos authentification" feature.

======
This project was originally developed during Facebook Hackathon 2014 organized by Hackers@EPFL (http://hackersatepfl.com).
