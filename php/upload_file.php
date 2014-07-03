<?php
session_start();
$output_dir = "/tmp/CloudPrintUpload/";
$answer = array();
$answer['error_code'] = 0;
$answer['files'] = array();

if(! isset($_FILES["file"])) {
  $answer['error_code'] = 1;
  goto end;
}

if(!isset($_SESSION['files'])){
  $_SESSION['files'] = array();
}

foreach ($_FILES["file"]['error'] as $error) {
  if ($error != 0) {
    $answer['error_code'] = $_FILES["file"]["error"];
    goto end;
  } 
}

for ($i=0; $i < sizeof($_FILES["file"]); $i++) { 
  $file_name = $_FILES["file"]["name"][$i];
  $server_file_name = preg_replace("/(\\.)([^.\\s]{3,4})$/", "${1}-" . time() . "-" . rand() . ".$2", $file_name);

  //move the uploaded file to uploads folder and check if success
  $return = move_uploaded_file($_FILES["file"]["tmp_name"][$i], $output_dir . $server_file_name);

  array_push($_SESSION['files'], array('file_name' => $file_name, 'server_file_name' => $server_file_name));
  array_push($answer['files'], array('file_name' => $file_name, 'server_file_name' => $server_file_name));
}

end:
echo json_encode($answer);
?>

