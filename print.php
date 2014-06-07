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

if(!isCredentialCorrect($_POST["gaspar"],$_POST["password"])){
	$answer = array("error_code" => 1000);
} else {

	if(isset($_POST['dropbox_url'])) {
		// create file name
    $name = str_replace(' ', '', $_POST[file_name]);
    $name = str_replace('-', '', $name);
    $name = str_replace('(', '', $name);
    $name = str_replace(')', '', $name);
		$name = preg_replace("/(\\.)([^.\\s]{3,4})$/", "${1}-" . time() . "-" . rand() . ".$2", $name);

		// fetch content
		$content = file_get_contents($_POST['dropbox_url']);
		$success = file_put_contents("uploads/" . $name, $content);
		$_POST['server_file_name'] = $name;

		if(! $content || ! $success) {
			$answer = array("error_code" => 3);
		}
	}

	$options = array();

	if($_POST["selection"] === "selectedonly"){
	  array_push($options, "-P " . $_POST["from"] . "-" . $_POST["to"]);
	}

	array_push($options, "-n " . $_POST["numbercopies"]);

	if($_POST["doublesided"]){
	  array_push($options, "-o sides=two-sided-long-edge");  
	}
	
	if($_POST["black_white"]) {
  	  array_push($options, "-o JCLColorCorrection=BlackWhite");
	}

	array_push($options, "-t '" . $_POST["file_name"] . "'");

	$cmd = "./" . $SCRIPT . " '" . $_POST["gaspar"] . "' '" . $_POST["password"] . "' 'uploads/" . $_POST["server_file_name"] . "' '" . join(" ", $options) . "'";
	$answer["command"] = $cmd;
	shell_exec($cmd." >stdout.log 2>stderr.log");
}

echo json_encode($answer);

?>
