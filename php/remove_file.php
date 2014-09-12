<?php 
/*
  This script takes in argument a $POST['server_file_name'], check if it is in the user's session list 
  of files to be printed. If it is, remove it.
*/ 
  	session_start();
  	if(isset($_SESSION['username'])){
	  if(isset($_SESSION['files']) && isset($_POST['server_file_name'])) {
	    $_SESSION['files'] = array_filter($_SESSION['files'], function($f) {
	     return $f['server_file_name'] != $_POST['server_file_name'];
	   });
	  }
	}

?>