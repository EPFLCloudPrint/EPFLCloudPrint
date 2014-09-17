<?php
//echo "<pre>";
//print_r($_SERVER);
//exit;
/*
if ($_SERVER['REMOTE_ADDR'] != '127.0.0.1' && $_SERVER['REMOTE_ADDR'] != '::1'){
  if(!isset($_SERVER['HTTPS']) || $_SERVER['HTTPS'] == ""){
    $redirect = "https://".$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
    header("Location: $redirect");
  }
}

#Creat folder in /tmp for upload if it doesn't exist
if(!file_exists("/tmp/CloudPrintUpload/")){
  mkdir("/tmp/CloudPrintUpload/");
}
*/
include("tequila/login.php");
?>

<!DOCTYPE html>
<head>
  <meta name="viewport" content="width=device-width">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="shortcut icon" href="images/icons/favicon.ico">
  <link rel="apple-touch-icon" sizes="57x57" href="images/icons/apple-touch-icon-57x57.png">
  <link rel="apple-touch-icon" sizes="114x114" href="images/icons/apple-touch-icon-114x114.png">
  <link rel="apple-touch-icon" sizes="72x72" href="images/icons/apple-touch-icon-72x72.png">
  <link rel="apple-touch-icon" sizes="144x144" href="images/icons/apple-touch-icon-144x144.png">
  <link rel="apple-touch-icon" sizes="60x60" href="images/icons/apple-touch-icon-60x60.png">
  <link rel="apple-touch-icon" sizes="120x120" href="images/icons/apple-touch-icon-120x120.png">
  <link rel="apple-touch-icon" sizes="76x76" href="images/icons/apple-touch-icon-76x76.png">
  <link rel="apple-touch-icon" sizes="152x152" href="images/icons/apple-touch-icon-152x152.png">
  <link rel="icon" type="image/png" href="images/icons/favicon-196x196.png" sizes="196x196">
  <link rel="icon" type="image/png" href="images/icons/favicon-160x160.png" sizes="160x160">
  <link rel="icon" type="image/png" href="images/icons/favicon-96x96.png" sizes="96x96">
  <link rel="icon" type="image/png" href="images/icons/favicon-16x16.png" sizes="16x16">
  <link rel="icon" type="image/png" href="images/icons/favicon-32x32.png" sizes="32x32">
  <meta name="msapplication-TileColor" content="#2b5797">
  <meta name="msapplication-TileImage" content="images/icons/mstile-144x144.png">
  <meta name="msapplication-config" content="images/icons/browserconfig.xml">
  <title>EPFLCloudPrint</title>


  <link href='https://fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
  <link rel="stylesheet" type="text/css" href="skeleton/base.css" />
  <link rel="stylesheet" type="text/css" href="skeleton/skeleton.css" />
  <link rel="stylesheet" type="text/css" href="skeleton/layout.css" />
  <link rel="stylesheet" type="text/css" href="styles.css" />

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js" ></script>
  <script type="text/javascript" src="https://www.dropbox.com/static/api/2/dropins.js" id="dropboxjs" data-app-key="gv048u7pj3hnrec"></script>
  <script type="text/javascript" src="script.js"></script>
</head>
<body>
  <noscript><?php include("noscript.html") ?></noscript>

  <div class="header">
    <img class="logout svgfallback" id="logoutIcon" src="images/logout.svg"/>
    <p><?php echo $_SESSION['name']; ?></p>
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
          UPLOAD YOUR FILES
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
      <a  href="https://github.com/EPFLCloudPrint/EPFLCloudPrint" target="_blank">
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
