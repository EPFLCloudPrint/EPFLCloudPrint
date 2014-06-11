<?php

/*
	ERROR_CODE :
		* 1 -> printing problem
		* 2 -> dropbox fetching problem
		* 3 -> incorrect credentials
*/

function areCredentialsCorrect($user, $passwd) {
	$url = 'https://tequila.epfl.ch/cgi-bin/tequila/login';
	$data = array('username' => $user, 'password' => $passwd);
	
	$options = array(
		'http' => array(
			'method'  => 'POST',
			'content' => http_build_query($data),
			)
		);
	$context  = stream_context_create($options);
	$result = file_get_contents($url, false, $context);
	
	$DOM = new DOMDocument;
	$DOM->loadHTML($result);
	return ($DOM->getElementsByTagName('title')->item(0)->nodeValue) === "Tequila";
}

$answer = array("error_code" => 0);

// CREDENTIAL CHECK
if( !areCredentialsCorrect($_POST["gaspar"],$_POST["password"]) ){
	$answer = array("error_code" => 3);
	goto end;
} 

// DROPBOX FETCHING
if(isset($_POST['dropbox_url'])) {
		// create file name
	$removed = array(' ', '_', '_', '(', ')');
	$name = str_replace($removed, '', $_POST[file_name]);
	$name = preg_replace("/(\\.)([^.\\s]{3,4})$/", "${1}-" . time() . "-" . rand() . ".$2", $name);

	// fetch content
	$content = file_get_contents($_POST['dropbox_url']);
	$success = file_put_contents("uploads/" . $name, $content);
	$_POST['server_file_name'] = $name;

	if(! $content || ! $success) {
		$answer = array("error_code" => 2);
		goto end;
	}
}

// PRINTER CREATION

$printer = "Pool1-" . $_POST['gaspar'] . "-" . rand();
$cmd_create = 'lpadmin -p ' . $printer . ' -E -v \'smb://' . $_POST['gaspar'] . ':' . $_POST['password'] . '@print1.epfl.ch/pool1\' -P /usr/share/cups/model/xr_WorkCentre7655R.ppd 2>&1';
$answer['cmd_create'] = $cmd_create;
$return = shell_exec($cmd_create);
if($return !== NULL) {
	$answer["error_code"] = 1;
	$answer['error_status'] = $return;
	goto end;
}

// PRINT

$options = array();

if($_POST["selection"] === "selectedonly"){
	array_push($options, "-P " . $_POST["from"] . "-" . $_POST["to"]);
}

array_push($options, "-n " . $_POST["numbercopies"]);

if($_POST["doublesided"]){
	array_push($options, "-o sides=two-sided-long-edge");  
}

if($_POST["blackwhite"]) {
	array_push($options, "-o JCLColorCorrection=BlackWhite");
}

array_push($options, "-t '" . $_POST["file_name"] . "'");

$cmd_print = 'lp -d ' . $printer . ' ' . join(" ", $options) . " 'uploads/" . $_POST["server_file_name"] . "' 2>&1";
$answer['cmd_print'] = $cmd_print;
$return = shell_exec($cmd_print);

end:
echo json_encode($answer);

?>
