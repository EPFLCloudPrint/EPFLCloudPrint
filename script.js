
$(document).ready(function() {

  /* MY FRAMEWORK */

  $('.checkbox').on("click", function() {
    event.preventDefault();
    if($(this).hasClass('checked')) {
      $(this).removeClass('checked').addClass('unchecked');
    } else {
      $(this).removeClass('unchecked').addClass('checked');
    }
    $(this).trigger("classChanged");
  });

  $('.radiobox').on("click", function() {
    event.preventDefault();
    if($(this).hasClass('unchecked')) {
      $(this).parents('.radioGroup').children('.radiobox').removeClass('checked').addClass('unchecked');
      $(this).removeClass('unchecked').addClass('checked');
      $(this).parents('.radioGroup').children('.radiobox').trigger("classChanged");
    }
  });

  $('.label').on("click", function() {
    event.preventDefault();
    $('.' + $(this).attr('for')).click();
  });

  /* PAGE ORGANISATION */

  var centering = function() {
    if($('.container').width() >=  768) {
      /* cloud position */
      var h = Math.max(0, ($('.container').height() - $('.footer').height() - $('.foreground').height()) / 2);
      $('.cloud').css('margin-top', h);

      /* dialog position */
      var h = Math.max(0, ($('.container').height() - $('.footer').height() - $('.dialog').height()) / 2);
      $('.dialog').css('margin-top', h);
    } else {
      $('.cloud').css('margin-top', 0);
      $('.dialog').css('margin-top', 0);
    }
  }

  var continuousCentering = function() {
    var proc = setInterval(centering, 10);
    setTimeout(function() {
      clearInterval(proc);
    }, 3000);
  }

  $(window).resize(centering);
  $('.dialog').on('heightChange', continuousCentering);

  centering();

  /* footer position */
  var h = $('.footer').height();
  var w = $('.footer').width();
  $('.cloud').css('padding-bottom', h);
  $('.dialog').css('padding-bottom', h);
  $('.footer').css('height', h);


  /* PAGE REACTIONS */

  /* upload button reaction */
  $('#upload_button').on("click", function() {
    viewOptions();
    uploadFile();
  });

  /* dropbox button reaction */
  if(Dropbox.isBrowserSupported()){

  $('#dropbox_button').show().on("click", function() {
    Dropbox.choose(dbox_options);
  });
}

  /* page selection hide/show */
  $('.selectedonly').on("classChanged", function() {
    if($(this).hasClass('checked')) {
      $('#fromto').slideDown('normal');
      $('#from').val("");
      $('#to').val("");
    } else {
      $('#fromto').slideUp('normal');
    }
    $('.dialog').trigger('heightChange');
  });

});

/* CLOUD PROGRESSION */
function setProgression(percentage) {
  $("#tick_path").hide();
  $('stop').attr('offset', percentage+'%');
}

function endUpload() {
  setProgression(0);
  $("#tick_path").show();
  $(".cloud p").hide();
}

/* FUNCTIONNALITIES */
function uploadFile() {
  progressing();
}

function printed() {
  $('.options').hide();
  $('#upload_button').html("UPLOAD NEW FILE");
  $('#upload_button').show();
  $('.dialog').trigger("heightChange");
}

function viewOptions() {
  $('#upload_button').hide();
  $('#dropbox_button').hide();
  $('h1').attr('style', 'margin-bottom: 40px;');
  $('.options').slideDown(1000);
  $('.cloud p').fadeIn(1000);
  $('.dialog').trigger('heightChange');
}

/* DEMO */

$(".print").on("click", printed);

function progressing(){
  var p = parseInt($('stop').attr('offset').replace('%', ''));
  if(p < 100) {
    setProgression(p + 1);
    setTimeout(progressing, 50);
  } else {
    setTimeout(endUpload, 500);
  }
}

/*  DROPBOX HANDLING OPTIONS  */

var dbox_options = {
    success: function(files) {
      uploadFile();
      viewOptions();
    },

    cancel: function() { },

    linkType: "direct", // or "preview"

    multiselect: false, // or true

    extensions: ['.pdf'],
};
