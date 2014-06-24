<?php /*
  This script takes in argument a $POST['server_file_name'], check if it is in the user's session list 
  of files to be printed. If it is, remove it.
*/ 
  session_start();
  $_SESSION['files'] = array_filter($_SESSION['files'], function($f) {
  	return f['server_file_name'] != $POST['server_file_name'];
  });
  
  ?>