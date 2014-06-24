<?php
session_start();
/*
	ERROR_CODE :
		* 1 -> printing problem
		* 2 -> dropbox fetching problem
		* 3 -> incorrect credentials
*/

		$answer = array("error_code" => 0);

		foreach ($_SESSION['files'] as $f) {

// PRINT

			$options = array();

			if($_POST["selection"] === "selectedonly"){
				array_push($options, escapeshellarg("-o page-ranges=" . $_POST["from"] . "-" . $_POST["to"]));
			}

			array_push($options, escapeshellarg("-#" . $_POST["numbercopies"]));

			if($_POST["doublesided"]){
				array_push($options, "-o sides=two-sided-long-edge");  
			}

			if($_POST["blackwhite"]) {
				array_push($options, "-o JCLColorCorrection=BlackWhite");
			}

			array_push($options, escapeshellarg("-T " . $f['file_name']));
			


			$printer='mainPrinter';
			$cmd_print = 'lpr -P ' . escapeshellarg($printer) . ' -U '. escapeshellarg($_SESSION['username']) .' ' . join(' ', $options) . ' ' . escapeshellarg('/tmp/CloudPrintUpload/'.$f['server_file_name']) . " 2>&1";
			$return = shell_exec($cmd_print);
			$file = fopen("test.txt","w");
			fwrite($file,$cmd_print);
			fclose($file);
		}

		end:
		echo json_encode($answer);
		session_destroy();
?>