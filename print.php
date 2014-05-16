<?php
$DEBUG = "ON";
$SCRIPT="script.sh";
$name = $_POST["name"];
$OPTIONS = array();

$name = str_replace(' ', '', $_POST["file_name"]);
$name = str_replace('-', '', $name);

if($_POST["selection_all"] === "on"){
	echo "print all page\n";
}

if($_POST["selection_selected"] === "on"){
  array_push($OPTIONS, "-P " . $_POST["from"] . "-".$_POST["to"]);
}

array_push($OPTIONS, "-n " . $_POST["copies"]);

if($_POST["double_sided"] === "on"){
    array_push($OPTIONS, "-o sides=two-sided-long-edge");  
}

$cmd = "./".$SCRIPT . " " . $_POST["user"] . " " . $_POST["password"] . " uploads/" .  $name . " '" . join(" ",$OPTIONS)."'";

echo $cmd;
shell_exec($cmd." >stdout.log 2>stderr.log");

print_r($_POST);

header( 'Location: index.html' ) ;

?>
