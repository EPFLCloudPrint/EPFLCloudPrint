<?php
require_once("tequila.php");

$oClient = new TequilaClient();

$oClient->SetApplicationName('CloudPrint');
$oClient->SetWantedAttributes(array('user','name','firstname'));

$oClient->Authenticate ();

$nom = $oClient->getValue('name');
$prenom = $oClient->getValue('firstname');

if(strpos($prenom, ',')) {
  $name = substr($prenom, 0, strpos($prenom, ',')) . " " . $nom;
} else if(strpos($prenom, ' ')) {
  $name = substr($prenom, 0, strpos($prenom, ' ')) . " " . $nom;
} else {
  $name = $prenom . " " . $nom;
}

$user = $oClient->getValue('user');
echo "<script> var gaspar = '" . $user . "'</script>";
?>
