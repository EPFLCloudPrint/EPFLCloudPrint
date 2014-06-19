$(document).ready(function() {

  var message = function(message) {
    $(".cloud .message").html(message).fadeIn(1000, centerCloud);
  }

  /* PAGE DISPOSITION */

  var centerCloud = function() {
    if($('div.container').width() >=  768) {
      var h = Math.max(0, ($('.container').height() - 45 - $('.cloud').height()) / 2);
      $('.cloud').css('margin-top', h);
    } else {
      $('.cloud').css('margin-top', 0);
    }
  }

  var centerDialog = function() {
    if($('.container').width() >=  768) { // desktop
      var h = Math.max(0, ($('div.container').height() - 45 - $('div.dialog').height()) / 2);
      $('.dialog').css('margin-top', h);
    } else { // mobile
      $('.dialog').css('margin-top', 0);
    }
  }

  var centerUploadButton = function() {
    var w = $('.container').width();
    if(w == 300) {
      $('.upload._button').css('margin-left', ($('.dialog').width() - $('.upload._button').width())/2);
      $('.dropbox._button').css('margin-left', ($('.dialog').width() - $('.dropbox._button').width())/2);
    } 
    if(w == 420 || w == 960 ){
      $('.upload._button').css('margin-left', 0);
      $('.dropbox._button').css('margin-left', "10px");
    } 
    if(w == 768){
      $('.upload._button').css('margin-left', 0);
      $('.dropbox._button').css('margin-left', 0);
    }
  };

  centerCloud();
  centerDialog();
  centerUploadButton();

  $(window).resize(function() {
    centerCloud();
    centerDialog();
    centerUploadButton();
  });

  var centeringProcessing = [];

  var startCentering = function() {
    var proc = setInterval(function() {
      centerCloud();
      centerDialog();
    }, 10);
    centeringProcessing.push(proc);
  }
  
  var stopCentering = function() {
      if(centeringProcessing.length > 0) {
      var proc = centeringProcessing.shift();
      clearInterval(proc);
    }
  }

  /* PAGE TRANSFORMATIONS */

  /* page selection hide/show */
  $('.selection._radioGroup').on("valueChanged", function() {
    startCentering();
    if($(this).children('.selectedonly').hasClass('_checked')) {
      $('.fromto').slideDown('normal', stopCentering);
      $('.from._numberField').val("");
      $('.to._numberField').val("");
    } else {
      $('.fromto').slideUp('normal', stopCentering);
    }
  });

  var toggleTheUploadMode = function(buttonName) {
    $('.options').hide();
    $('.formUpload')[0].reset();
    $('.upload._button').html(buttonName);
    $('._empty._button').show(0, function() {
      centerDialog();
      centerCloud();
    });
  }

  var toggleThePrintMode = function() {
    startCentering();
    $('._empty._button').hide();
    $('.options').slideDown(1000, stopCentering);
  }

  /* FEATURES */

  $('#cloud_path').on('click', function(){
    $('.fileInput').click();
  });

  $('.upload._button').on('click', function() {
    $('.fileInput').click();
  });

  $("form.formUpload").on("change", function(e) {
    var files = $(".fileInput")[0].files;
    for(var i = 0; i < files.length; i++) {
      uploadFile(files[i]);
    }
  });

  $(".from").on('change', function() {
    $(".to").attr('min', $(".from").val());
    $(".to").check();
  });

  /* DRAG AND DROP */

  $(document.body).bind("dragover", function(e) {
    e.preventDefault();
    return false;
  });

  $(document.body).bind("drop", function(e){
    e.preventDefault();
    return false;
  });

  var ticked = false;

  $('#cloud_path').bind("dragenter", function(e) {
    ticked = ($('#tick_path').css('display') != 'none' );
    showTick(false);

    $('#arrow_path').css('fill', '#34495e');
    $('#arrow_path').css('stroke', '#34495e');
  });

  $('#cloud_path').bind("dragleave", function(e) { 
    if(ticked) {
      showTick(true);
    }
    $('#arrow_path').css('fill', 'none');
    $('#arrow_path').css('stroke', 'none');  
  });

  $('#cloud_path').bind("drop", function(e){
    $('#arrow_path').css('fill', 'none');
    $('#arrow_path').css('stroke', 'none');  
    var files = e.originalEvent.target.files || e.originalEvent.dataTransfer.files;
    for(var i = 0; i < files.length; i++) {
      if( files[i].type === "application/pdf") {
        uploadFile(files[i]);
      } else {
        $('#cloud_path').trigger('dragleave');
      }
    }
  });

  $('.upload._button').bind("drop", function(e){
    $('#cloud_path').attr('fill', 'url(#progression)');
    var files = e.originalEvent.target.files || e.originalEvent.dataTransfer.files;
    for(var i = 0; i < files.length; i++) {
      if( files[i].type === "application/pdf") {
        uploadFile(files[i]);
      }
    }
    $(this).removeClass('drop');   
  });

  $('.upload._button').bind("dragenter", function(e) {
    $(this).addClass('drop');
  });

  $('.upload._button').bind("dragleave", function(e) { 
    $(this).removeClass('drop');   
  });


  /* LOGOUT */
  $('.logout').click(function() {
    location.replace('tequila/logout.php');
  });

});
