# EPFLCloudPrint

## Overview

*EPFLCloudPrint* is a simple web service to bring remote printing to handheld devices.
This project was created to be able to send files to EPFL's printing pool from mobile phones and tablets. It is also an alternative way to print from your computer without having to install the printer's driver.
Its uses aren't limited to our university but can be ported to any company or university server, so users can print from any browser.

## Apache Server configuration

- enable php on the server : uncomment `LoadModule php5...` line in configuration file `/etc/apache2/httpd.conf`,
- fix the `upload_max_filesize` option in `/etc/php.ini`,
- `wget` the correct printer driver and install it,
- run `$ Administration/install.sh` to configure the server printer (Mac OSX users might need to add `sudo`),
- start the server with `# apachectl start`,
- everything should be ok, you can test from `localhost` in your browser.

======
This project was originally developed during Facebook Hackathon 2014 organized by Hackers@EPFL (http://hackersatepfl.com).
