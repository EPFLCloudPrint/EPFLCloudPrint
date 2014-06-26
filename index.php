<?php

if ($_SERVER['REMOTE_ADDR'] != '127.0.0.1' && $_SERVER['REMOTE_ADDR'] != '::1'){
  if(!isset($_SERVER['HTTPS']) || $_SERVER['HTTPS'] == ""){
    $redirect = "https://".$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
    header("Location: $redirect");
  }
}

include("tequila/login.php");
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta name="viewport" content="width=device-width">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="icon" type="image/png" href="images/favicon.png" />
  <link rel="icon" type="image/x-icon" href="images/favicon.ico" />
  <title>EPFLCloudPrint</title>
</head>

<link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'>
<link rel="stylesheet" type="text/css" href="skeleton/base.css" />
<link rel="stylesheet" type="text/css" href="skeleton/skeleton.css" />
<link rel="stylesheet" type="text/css" href="skeleton/layout.css" />
<link rel="stylesheet" type="text/css" href="styles.css" />

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js" ></script>
<script type="text/javascript" src="https://www.dropbox.com/static/api/2/dropins.js" id="dropboxjs" data-app-key="gv048u7pj3hnrec"></script>
<script type="text/javascript" src="script.js"></script>

<body>
  <noscript><?php include("noscript.html") ?></noscript>

  <div class="header">
    <img class="logout svgfallback" id="logoutIcon" src="images/logout.svg"/>
    <p><?php echo $name; ?></p>
  </div>

  <div class="container">
    <h1 class="mobile" style="display:none;" ><span class="colored">EPFL</span>CloudPrint</h1>

    <div class="desktop ghost two columns alpha" style="visibility: hidden">hidden</div>

    <div id="cloud" class="six columns">
      <?php include("images/cloud.svg") ?>
      <p id="message" style="display:none">
      </p>
      <ul id="fileList">
      </ul>
    </div>

    <div id="dialog" class="eight columns omega">
      <h1 class="eight columns alpha desktop" ><span class="colored">EPFL</span>CloudPrint</h1>

      <div id="buttonWrapper" class="eight columns">
        <div id="uploadButton" class="_button _empty">
          UPLOAD YOUR FILE
        </div>
        <div id="dropboxButton" class="_button _empty" style="display: none;">
          LOOK IN DROPBOX
        </div>
      </div>

      <div class="options six columns alpha" style="display: none;">
        <form id="printForm">

          <!-- Options -->
          <div class="six columns alpha">

            <div class="three columns alpha">
              <h5>Number of copies</h5>
              <input type="text" class="_numberField two columns alpha" value="1" min="1" name="numbercopies"/>
            </div>

            <div class="three columns omega">

              <h5>Printing Options</h5>

              <div class="doublesided _checkbox _checked" name="doublesided"></div>
              <span class="_label" for="doublesided"> Double sided </span><br/>

              <div class="blackwhite _checkbox _checked" name="blackwhite"></div>
              <span class="_label" for="blackwhite"> Black & white </span>
            </div>

            <br class="clear" />

            <div class="_radioGroup selection" name="selection">
              <h5>Pages</h5>

              <div class="all _radiobox _checked" name="all"></div>
              <span class="_label" for="all"> All </span><br/>

              <div class="selectedonly _radiobox _unchecked" name="selectedonly"></div>
              <span class="_label" for="selectedonly"> Selected only </span><br/>
              <div class="fromto" style="display: none;">
                <input id="from" class="two columns alpha from _numberField" min="1" type="text" placeholder="From" name="from" />
                <input id="to" class="two columns omega to _numberField" min="1" type="text" placeholder="To" default="1" name="to" />
              </div>
            </div>

            <div id="printButton" class="_full _button _disabled submit five columns alpha">PRINT</div>
          </div>
        </form>
      </div>
    </div>

    <br class="clear"/>
  </div>

  <div id="footer">
    <p>
      <a  href="https://github.com/giacomogiudice/EPFLCloudPrint" target="_blank">
        <img class="svgfallback" src="images/GitHub.svg" alt="GitHub link"/>
      </a>
      Jean-Baptiste Cordonnier, Charles Gallay and Giacomo Giudice
    </p>
  </div>

  <!-- This is utility invisible things -->
  <form class="formUpload" action="upload_file.php" method="post" enctype="multipart/form-data">
    <input type="file" name="file" class="fileInput" accept="application/pdf" style="display:none" multiple>
  </form>
</body>
</html>
