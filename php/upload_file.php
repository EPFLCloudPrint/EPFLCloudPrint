<?php
session_start();
$output_dir = "/tmp/CloudPrintUpload/";
$answer = array();
$answer['error_code'] = 0;

if(!isset($_SESSION['files'])){
  $_SESSION['files'] = array();
}

if(isset($_FILES["file"])) {
    if ($_FILES["file"]["error"] > 0) {
      $answer['error_code'] = $_FILES["file"]["error"];
    } else {
      $server_file_name = preg_replace("/(\\.)([^.\\s]{3,4})$/", "${1}-" . time() . "-" . rand() . ".$2", $_FILES["file"]["name"]);
	
      array_push($_SESSION['files'],array('file_name' => $_FILES["file"]["name"], 'server_file_name' => $server_file_name));
      
      //move the uploaded file to uploads folder and check if success
      $ok = move_uploaded_file($_FILES["file"]["tmp_name"], $output_dir . $server_file_name);
      if(! $ok) {
        $answer['error_code'] = 2;
      }

      $answer['file_name'] = $_FILES["file"]["name"];
      $answer['server_file_name'] = $server_file_name;

      $file = fopen("test".rand().".txt","w");
      fwrite($file,print_r($_FILES["file"],true));
      fclose($file);
    }
} else {
  $answer['error_code'] = 1;
}

echo json_encode($answer);
?>

