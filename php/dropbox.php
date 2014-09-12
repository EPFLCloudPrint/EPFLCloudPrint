<?php
session_start();
$output_dir = "/tmp/CloudPrintUpload/";
$answer = array();
$answer['error_code'] = 0;

if(!isset($_SESSION['username'])){
  $answer['error_code'] = 3;
  goto end;
}

if(!isset($_SESSION['files'])){
  $_SESSION['files'] = array();
}

if(isset($_POST['dropbox_url'])) {
  $file_name = $_POST['file_name'];
  $server_file_name = preg_replace("/(\\.)([^.\\s]{3,4})$/", "${1}-" . time() . "-" . rand() . ".$2", $file_name);

  // fetch content
  $content = file_get_contents($_POST['dropbox_url']);
  $success = file_put_contents("/tmp/CloudPrintUpload/" . $server_file_name, $content);

  if(! $content || ! $success) {
    $answer = array("error_code" => 2);
    goto end;
  }

  array_push($_SESSION['files'], array('file_name' => $file_name, 'server_file_name' => $server_file_name));
  
  $answer['file_name'] = $file_name;
  $answer['server_file_name'] = $server_file_name;
} else {
  $answer['error_code'] = 1;
}

end:
echo json_encode($answer);
?>