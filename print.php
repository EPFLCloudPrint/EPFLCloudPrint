<?php

$SCRIPT="print.sh";
$answer = array("error_code" => 0);

$options = array();

if($_POST["selection_selected"] === "on"){
  array_push($options, "-P " . $_POST["from"] . "-" . $_POST["to"]);
}

array_push($options, "-n " . $_POST["number_copies"]);

if($_POST["double_sided"] === "on"){
  array_push($options, "-o sides=two-sided-long-edge");  
}

if($_POST["black_white"] === "on") {
  array_push($options, "-o JCLColorCorrection=BlackWhite");
}

array_push($options, "-t " . $_POST["file_name"]);

$cmd = "./" . $SCRIPT . " '" . $_POST["user"] . "' '" . $_POST["password"] . "' 'uploads/" . $_POST["server_file_name"] . "' '" . join(" ", $options) . "'";
$answer["command"] = $cmd;
shell_exec($cmd." >stdout.log 2>stderr.log");

echo json_encode($answer);
?>
