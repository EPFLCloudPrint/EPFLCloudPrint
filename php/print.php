<?php
session_start();
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

		if( ! isset($_SESSION['files']) ) {
			$answer['error_code'] = 5;
			goto end;
		}

		if(sizeof($_SESSION['files']) > 12) {
			$answer['error_code'] = 4;
			goto end;
		}

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
			$printer='mainPrinter';
			$cmd_print = 'lpr -P ' . escapeshellarg($printer) . ' -U ' . escapeshellarg($_SESSION['username']) . ' ' . join(' ', $options) . ' ' . escapeshellarg('/tmp/CloudPrintUpload/'.$f['server_file_name']) . " 2>&1";
			$return = shell_exec($cmd_print);
			// array_push($answer['comands'], $cmd_print);
		}
    
		echo json_encode($answer);
?>