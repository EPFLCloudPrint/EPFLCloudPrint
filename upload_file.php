<?php

$output_dir = "uploads/";
$answer = array();
$answer['error_code'] = 0;

if(isset($_FILES["file"])) {
  if ($_FILES["file"]["error"] > 0) {
    $answer['error_code'] = $_FILES["file"]["error"];
  } else {
    $answer['file_name'] = $_FILES["file"]["name"];

    //remove special char
    $name = str_replace(' ', '', $_FILES["file"]["name"]);
    $name = str_replace('-', '', $name);
    $name = str_replace('(', '', $name);
    $name = str_replace(')', '', $name);
    $name = preg_replace("/(\\.)([^.\\s]{3,4})$/", "${1}-" . time() . "-" . rand() . ".$2", $name);
    $answer['server_file_name'] = $name;	

    //move the uploaded file to uploads folder and check if success
    $ok = move_uploaded_file($_FILES["file"]["tmp_name"], $_SERVER["DOCUMENT_ROOT"] . "/" . $output_dir . $name);
    if(! $ok) {
      $answer['error_code'] = 2;
    }
  }
} else {
  $answer['error_code'] = 1;
}

echo json_encode($answer);
?>

