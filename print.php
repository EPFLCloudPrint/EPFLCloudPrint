<?php

$SCRIPT="print.sh";
$answer = array("error_code" => 0);
$name = $_POST["server_file_name"];

$options = array();

if($_POST["selection_selected"] === "on"){
  array_push($options, "-P " . $_POST["from"] . "-" . $_POST["to"]);
}

array_push($options, "-n " . $_POST["number_copies"]);

if($_POST["double_sided"] === "on"){
  array_push($options, "-o sides=two-sided-long-edge");  
}

$cmd = "./".$SCRIPT . " '" . $_POST["user"] . "' '" . $_POST["password"] . "' 'uploads/" .  $name . "' ' " . join(" ", $options) . " ' ";

$answer["command"] = $cmd;
shell_exec($cmd." >stdout.log 2>stderr.log");

echo json_encode($answer);
?>
