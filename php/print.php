<?php
session_start();
$time_start = microtime(true);
/*
ERROR_CODE :
* 1 -> printing problem
* 2 -> dropbox fetching problem
* 3 -> incorrect credentials
* 4 -> too many files
* 5 -> no files stored in the session
*/

$answer = array("error_code" => 0);
// $answer["comands"] = array();
// $answer["files"] = $_SESSION['files'];
if(!isset($_SESSION['username'])){
	$answer['error_code'] = 3;
	goto end;
}

if( ! isset($_SESSION['files']) ) {
	$answer['error_code'] = 5;
}
elseif(sizeof($_SESSION['files']) > 12) {
	$answer['error_code'] = 4;
}
else{
	foreach ($_SESSION['files'] as $f) {

		// OPTIONS
		$options = array();

		if($_POST["selection"] === "selectedonly"){
			array_push($options, escapeshellarg("-o page-ranges=" . $_POST["from"] . "-" . $_POST["to"]));
		}

		array_push($options, "-# " . escapeshellarg($_POST["numbercopies"]));

		if($_POST["doublesided"]){
			array_push($options, "-o sides=two-sided-long-edge");
		}

		if($_POST["blackwhite"]) {
			array_push($options, "-o JCLColorCorrection=BlackWhite");
		}

		array_push($options, "-T " . escapeshellarg($f['file_name']));

		// PRINT
		$printer = 'mainPrinter';
		$cmd_print = 'lpr -r -P ' . escapeshellarg($printer) . ' -U ' . escapeshellarg($_SESSION['username']) . ' ' . join(' ', $options) . ' ' . escapeshellarg('/tmp/CloudPrintUpload/'.$f['server_file_name']) . " 2>&1";
		if (shell_exec($cmd_print)){
			$answer['error_code'] = 1;
		}
		// array_push($answer['comands'], $cmd_print);
	}
}
$time_stop = microtime(true);
$bytes = 0;
foreach ($_SESSION['files'] as $f){
	 $total_filesize += filesize('/tmp/CloudPrintUpload/'. $f['server_file_name']);
}

$log_data = array(
	time      => time(),    // s since Unix epoch
	dt 	     => round(($time_stop - $time_start)*1000),    // in ms
	uid	     => hash('md5', $_SESSION['username']),    // hashed for privacy
	filecount => count($_SESSION['files']),
	bytes     => $total_filesize,
	error     => $answer['error_code']
);

file_put_contents("../Administration/stats.csv",  implode(',', $log_data) . "\n", FILE_APPEND);

unset($_SESSION['files']);
end:
echo json_encode($answer);
?>
