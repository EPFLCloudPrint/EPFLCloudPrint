<?php
session_start();
/*
	ERROR_CODE :
		* 1 -> printing problem
		* 2 -> dropbox fetching problem
		* 3 -> incorrect credentials
*/

		$answer = array("error_code" => 0);

		for ($i=0; $i < sizeof($_POST['files']); $i++) {

			$file =  $_POST['files'][$i];

// DROPBOX FETCHING
			if(isset($file['dropbox_url'])) {
		// create file name
				$removed = array(' ', '_', '_', '(', ')');
				$name = str_replace($removed, '', $file['file_name']);
				$name = preg_replace("/(\\.)([^.\\s]{3,4})$/", "${1}-" . time() . "-" . rand() . ".$2", $name);

	// fetch content
				$content = file_get_contents($file['dropbox_url']);
				$success = file_put_contents("/tmp/CloudPrintUpload/" . $name, $content);
				$_POST['server_file_name'] = $name;

				if(! $content || ! $success) {
					$answer = array("error_code" => 2);
					goto end;
				}
			}

// PRINT

			$options = array();

			if($_POST["selection"] === "selectedonly"){
				array_push($options, "-o page-ranges=" . $_POST["from"] . "-" . $_POST["to"]);
			}

			array_push($options, "-#" . $_POST["numbercopies"]);

			if($_POST["doublesided"]){
				array_push($options, "-o sides=two-sided-long-edge");  
			}

			if($_POST["blackwhite"]) {
				array_push($options, "-o JCLColorCorrection=BlackWhite");
			}

			array_push($options, "-T " . $_SESSION["file_name"]);

			$printer='mainPrinter';
			$cmd_print = 'lpr -P ' . escapeshellarg($printer) . ' -U '. escapeshellarg($_SESSION['username']) .' ' . join(' ', escapeshellarg($options)) . ' /tmp/CloudPrintUpload' . escapeshellarg($_SESSION["server_file_name"]) . " 2>&1";
			$return = shell_exec($cmd_print);

		}

		end:
		echo json_encode($answer);
?>