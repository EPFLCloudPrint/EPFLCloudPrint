<?php

$output_dir = "uploads/";
 
if(isset($_FILES["file"]))
{
    //Filter the file types , if you want.
    if ($_FILES["file"]["error"] > 0)
    {
      echo "Error: " . $_FILES["file"]["error"] . "<br>";
    }
    else
    {
		//remove special char
        $name = str_replace(' ', '', $_FILES["file"]["name"]);
		$name = str_replace('-', '', $name);
		$name = str_replace('(', '', $name);
		$name = str_replace(')', '', $name);
		echo $name;	
		
        //move the uploaded file to uploads folder;
        move_uploaded_file($_FILES["file"]["tmp_name"],$_SERVER["DOCUMENT_ROOT"] . "/" . $output_dir. $_FILES["file"]["name"]);   
    }
}else{
	echo "big error";
}
?>

