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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script type="text/javascript" src="https://www.dropbox.com/static/api/2/dropins.js" id="dropboxjs" data-app-key="gv048u7pj3hnrec"></script>
<script src="script.js"></script>
<body>
  <div class="container">
    <h1 class="sixteen columns alpha mobile" style="display:none;" ><span class="colored">EPFL</span>CloudPrint</h1>

    <div class="desktop ghost two columns alpha" style="visibility: hidden">hidden</div>

    <div class="cloud six columns omega" >
      <?php include("images/cloud.svg") ?>
      <p class="message" style="display:none;">Uploading your file...</p>
    </div>

    <div class="dialog eight columns">
      <h1 class="eight columns alpha desktop" ><span class="colored">EPFL</span>CloudPrint</h1>

      <div id="button_wrapper eight columns">
        <div class="upload _button _empty">
          UPLOAD YOUR FILE
        </div>
        <div class="dropbox _button _empty" style="display: none;">
          LOOK IN DROPBOX
        </div>
      </div>
      
      <div class="options six columns alpha" style="display: none;">
        <form id="printForm">
          <!-- Credentials -->
          <input type="text" class="gaspar four columns alpha nonempty" placeholder="Gaspar" name="gaspar" />
          <input type="password" class="password four columns alpha nonempty" placeholder="Password" name="password" />

          <!-- Options -->
          <div class="six columns alpha omega">

            <h3>Options</h3>

            <div class="three columns alpha">
              <h5 class="three columns alpha">Number of copies</h5>
              <input type="text" class="_numberField one columns alpha" value="1" min="1" name="numbercopies"/>
            </div>

            <div class="three columns omega">

              <h5>Printing Options</h5>

              <div class="doublesided _checkbox _checked" name="doublesided"></div>
              <span class="_label" for="doublesided"> Double sided </span><br/>

              <div class="blackwhite _checkbox _checked" name="blackwhite"></div>
              <span class="_label" for="blackwhite"> Black & white </span>
            </div>

            <br class="clear" />

            <h5>Pages</h5>

            <div class="_radioGroup selection" name="selection">
              <div class="all _radiobox _checked" name="all"></div>
              <span class="_label" for="all"> All </span><br/>

              <div class="selectedonly _radiobox _unchecked" name="selectedonly"></div>
              <span class="_label" for="selectedonly"> Selected only </span><br/>
              <div class="fromto" style="display: none">
                <div class="two columns alpha" >
                  <input min="1" type="text" class="from _numberField" placeholder="From" name="from" />
                </div>
                <div class="two columns omega">
                  <input min="1" type="text" class="to _numberField" placeholder="To" default="1" name="to" />
                </div>
                <br class="clear"/>
              </div>
            </div>

            <div class="print _full _button _disabled submit five columns alpha">PRINT</div>
          </div>
        </form>
      </div>
    </div>

    <br class="clear"/>

    <div class="footer sixteen columns">
      <p>
        <a  href="https://github.com/giacomogiudice/EPFLCloudPrint" target="_blank">
          <img class="logo-github" src="images/GitHub.svg" alt="GitHub link"/>
        </a>
        Jean-Baptiste Cordonnier, Charles Gallay and Giacomo Giudice
      </p>
    </div>
  </div>
  <!-- This is utility invisible things -->
  <form class="formUpload" action="upload_file.php" method="post" enctype="multipart/form-data">
    <input type="file" name="file" class="fileInput" accept="application/pdf" style="display:none">
  </form>
</body>
</html>
