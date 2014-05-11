<?php
$SCRIPT="script.sh";
$name = $_POST["name"];
$OPTIONS = array();

$name = str_replace(' ', '', $_POST["file_name"]);
$name = str_replace('-', '', $name);

if($_POST["selection_all"] === "on"){
  array_push($OPTIONS, "-P " . $_POST["from"] . "-".$_POST["to"]);
}

array_push($OPTIONS, "-n " . $_POST["copies"]);

if($_POST["double_sided"] === "on"){
    array_push($OPTIONS, "-o sides=two-sided-long-edge");  
}

$cmd = "./".$SCRIPT . " " . $_POST["user"] . " " . $_POST["password"] . " uploads/" .  $name . " " . join(" ",$OPTIONS);

shell_exec($cmd);

//print_r($_POST);
header( 'Location: index.html' ) ;

?>
