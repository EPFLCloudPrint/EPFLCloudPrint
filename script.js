$(document).ready(function() {

  /* CHECK INPUT FILE SUPPORT */

  if($('[name="file"]').disabled)
  {
    $(".cloud .message").html("Error: Your browser doesn't seem to support file uploading").show();
    return;
  }

  /* MY FRAMEWORK */

  $('._checkbox').on("click", function() {
    event.preventDefault();
    if($(this).hasClass('_checked')) {
      $(this).removeClass('_checked').addClass('_unchecked');
    } else {
      $(this).removeClass('_unchecked').addClass('_checked');
    }
    $(this).trigger("valueChanged");
  });

  $('._radiobox').on("click", function() {
    if($(this).hasClass('_unchecked')) {
      $(this).parents('._radioGroup').children('._radiobox').removeClass('_checked').addClass('_unchecked');
      $(this).removeClass('_unchecked').addClass('_checked');
      $(this).parents('._radioGroup').children('._radiobox');
      $(this).parents('._radioGroup').trigger("valueChanged");
    }
  });

  $('._label').on("click", function() {
    event.preventDefault();
    $('.' + $(this).attr('for')).click();
  });

  $('form').attr('onSubmit', "return false;");

  $('.submit._button').on('click', function() {
    $(this).parents('form').trigger('submit');
  });

  var showError = function(field) {
    field.addClass('_error');
    field.on('click', function(event) {
      $(this).removeClass('_error');
      $(this).unbind(event);
    });
  }

  /* number field check */
  jQuery.fn.check = function() {
    if($(this).hasClass('_numberField')) {
      var min = $(this).attr('min');
      var max = $(this).attr('max');
      var def = $(this).attr('default');
      var v = parseInt($(this).val()) || def || min || 1;
      v = v >= min ? v : min;
      $(this).val(v);
    }
  }

  $('input._numberField').on('change', function() {
    $(this).check();
  });

  /* form validation and answer summary */
  jQuery.fn.validate = function() {
    var form = $(this);
    var result = {};

    form.find('input').each(function() {
      $(this).removeClass('_error');
    });

    form.find('input').each(function() {
      if(! $(this).hasClass('_numberField')) {
        if($(this).hasClass('nonempty') && $(this).val() === "") {
          result['error'] = true;
          showError($(this));
        } else {
          result[$(this).attr('name')] = $(this).val();
        }
      }
    });

    form.find('._checkbox').each(function() {
      result[$(this).attr('name')] = $(this).hasClass('_checked');
    });

    form.find('._numberField').each(function() {
      if($(this).val() !== "") {
        var value = parseInt($(this).val())
        if(value != NaN
          && (! $(this).attr('min') || value >= parseInt($(this).attr('min')))
          && (! $(this).attr('max') || value <= parseInt($(this).attr('max')))) {

          result[$(this).attr('name')] = value;
      } else {
        showError($(this));
        result['error'] = true;
      }
    }
  });

    form.find('._radioGroup').each(function() {
      var name = $(this).attr('name');
      form.find('._radiobox').each(function() {
        if($(this).hasClass('_checked')) {
          result[name] = $(this).attr('name');
        }
      });
    })

    return result;
  }

  /* CLOUD PROGRESSION */

  var setProgression = function(percentage) {
    $("#tick_path").hide();
    $('stop').attr('offset', percentage+'%');
  }

  var showTick = function(isFinished) {
    setProgression(0);
    if(isFinished == true) {
      $("#tick_path").show();
    } else {
      $("#tick_path").hide();
    }
  }

  var showMessageProgression = function(message) {
    startCentering();
    $(".cloud .message").html(message).fadeIn(1000, stopCentering);
  }

  var hideMessageProgression = function(message) {
    startCentering();
    $(".cloud .message").fadeOut(1000, stopCentering);
  }

  /* PAGE DISPOSITION */

  var centerCloud = function() {
    if($('div.container').width() >=  768) {
      var h = Math.max(0, ($('.container').height() - 45 - $('.foreground').height()) / 2);
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

  $('.cloud').on('click', function(){
    $('.fileInput').click();
  });

  $('.upload._button').on('click', function() {
    $('.fileInput').click();
  });

  $("form.formUpload").on("change", function(e) {
    var file = $(".fileInput")[0].files[0];
    if(file) {
      uploadFile(file);
    }
  });

  $(".from").on('change', function() {
    $(".to").attr('min', $(".from").val());
    $(".to").check();
  });

  var uploadFile = function(file) {
    upload_information = {};
    toggleThePrintMode();
    showMessageProgression('Uploading your file...');
    $('.print._button').addClass('_disabled');
    var fd = new FormData();
    fd.append('file', file );
    var xhr = new XMLHttpRequest();
    xhr.upload.addEventListener("progress", function(e) {
      setProgression(100*(e.loaded/ e.total));
    });
    xhr.addEventListener("loadend", function(e) {
      var rep = JSON.parse(e.currentTarget.responseText);
      if(rep['error_code'] == 0) {
        showTick(true);
        showMessageProgression('You have uploaded "<span class="filename">' + rep['file_name'] + '</span>"');
        if(rep['file_name'].length > 37) {
          $('.cloud p .filename').addClass('wrap');
        }
        upload_information = {
          'server_file_name' : rep['server_file_name'],
          'file_name' : rep['file_name']
        };
        $('.print._button').removeClass('_disabled');
      } else {
        showTick(false);
        showMessageProgression('An error occured, please retry...');
        toggleTheUploadMode("UPLOAD YOUR FILE");
      }
    });
    xhr.open("POST", "upload_file.php");
    xhr.send(fd);
  };

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
    showTick($('#tick_path').attr('display'));

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
    var files = e.originalEvent.dataTransfer.files;
    uploadFile(files[0]);
  });

  $('.upload._button').bind("drop", function(e){
    $('#cloud_path').attr('fill', 'url(#progression)')
    var files = e.originalEvent.dataTransfer.files;
    uploadFile(files[0]);
    $(this).removeClass('drop');
  });

  $('.upload._button').bind("dragenter", function(e) {
    $(this).addClass('drop');
  });

  $('.upload._button').bind("dragleave", function(e) {
    $(this).removeClass('drop');
  });

  /* PRINT SUBMISSION */

  var sendPrint = function() {
    var form = $('#printForm').validate();
    if(! form['error']) {
      for (var info in upload_information) { form[info] = upload_information[info]; }
      $('.print._button').addClass('_disabled');
      $.ajax('print.php', {
        type: "POST",
        data: form,
        success: function(response) {
          try {
            var rep = JSON.parse(response);
          } catch(e) {
            var rep = {'error_code' : -1};
          }
          if(rep['error_code'] == 0) {
            showMessageProgression('The document was sent to the printer');
            toggleTheUploadMode("UPLOAD NEW FILE");
            showTick(false);
          } else if(rep['error_code'] == 2) {
            showMessageProgression('A problem occured with dropbox');
          } else if(rep['error_code'] == 3) {
            showError($('.gaspar, .password'));
            showMessageProgression('Please check your credentials');
          } else {
            showMessageProgression('An error occured while printing the document...');
          }
        },
        error: function() {
          showMessageProgression('An error occured while printing the document...');
        },
        complete: function() {
          $('.print._button').removeClass('_disabled');
        }
      });
    }
  }

  $('.print._button').on('click', sendPrint);

  /* DROPBOX */
  if(Dropbox.isBrowserSupported()){
    $('.dropbox._button').show().on("click", function() {
      upload_information = {};
      Dropbox.choose({
        success: function(files) {
          upload_information = {
            'dropbox_url' : files[0].link,
            'file_name' : files[0].name
          };
          showTick(true);
          showMessageProgression('You chose "' + files[0].name + '"');
          toggleThePrintMode();
          $('.print._button').removeClass('_disabled');
        },
        error: function() {},
        linkType: "direct", // or "preview"
        multiselect: false, // or true
        extensions: ['.pdf']
      });
    });
  }

});

var upload_information = {};
