<?php
  session_destroy();
  function curServerURL() {
    $pageURL = 'http';
    if ($_SERVER["HTTPS"] == "on") {
      $pageURL .= "s";
    }
    $pageURL .= "://";
    if ($_SERVER["SERVER_PORT"] != "80") {
      $pageURL .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"];
    } else {
      $pageURL .= $_SERVER["SERVER_NAME"];
    }
    return $pageURL;
  }

  require_once("tequila.php");
  $oClient = new TequilaClient();
  $oClient->Authenticate();
  $oClient->Logout(curServerURL());
?>