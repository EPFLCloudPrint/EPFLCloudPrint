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
      goto end;
    } 

    $file_name = $_FILES["file"]["name"];
    $server_file_name = preg_replace("/(\\.)([^.\\s]{3,4})$/", "${1}-" . time() . "-" . rand() . ".$2", $file_name);

    array_push($_SESSION['files'], array('file_name' => $file_name, 'server_file_name' => $server_file_name));
    
    //move the uploaded file to uploads folder and check if success
    $return = move_uploaded_file($_FILES["file"]["tmp_name"], $output_dir . $server_file_name);
    if(! $return) {
      $answer['error_code'] = 2;
      goto end;
    }

    $answer['file_name'] = $file_name;
    $answer['server_file_name'] = $server_file_name;
} else {
  $answer['error_code'] = 1;
}

end:
echo json_encode($answer);
?>

