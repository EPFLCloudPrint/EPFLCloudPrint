<?php
  function curServerURL() {
    $pageURL = 'http';
//    if ($_SERVER["HTTPS"] == "on") {
//      $pageURL .= "s";
//    }
    $pageURL .= "://".$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
//    if ($_SERVER["SERVER_PORT"] != "80") {
//      $pageURL .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"];
//    } else {
//      $pageURL .= $_SERVER["SERVER_NAME"];
//    }
    return $pageURL;
  }

  session_start();
  if(!isset($_SESSION['username'])) {
    header("Location: ..");
    exit;
  }
  unset($_SESSION['username']);
  require_once("tequila.php");
  $oClient = new TequilaClient();
  //$oClient->Authenticate();
  $oClient->Logout(curServerURL());	//delete the tequila token in cookies
?>
