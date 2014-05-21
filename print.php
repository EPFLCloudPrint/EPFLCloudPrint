<?php

function isCredentialCorrect($user,$passwd) {
	$url = 'https://tequila.epfl.ch/cgi-bin/tequila/login';
	$data = array('username' => $user, 'password' => $passwd);
	
	$options = array(
	    'http' => array(
	        'method'  => 'POST',
	        'content' => http_build_query($data),
	    ),
	);
	$context  = stream_context_create($options);
	$result = file_get_contents($url, false, $context);
	
	$DOM = new DOMDocument;
	$DOM->loadHTML($result);
	return ($DOM->getElementsByTagName('title')->item(0)->nodeValue) === "Tequila";
}

$SCRIPT="print.sh";
$answer = array("error_code" => 0);
if(!isCredentialCorrect($_POST["user"],$_POST["password"])){
	$answer = array("error_code" => 1000);
} else {

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
}
echo json_encode($answer);

?>
