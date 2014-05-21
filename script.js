
$(document).ready(function(){

  /* 
    UPLOAD FILE FUNCTIONS
  */

  var preventDefault = function(e) {
    e.stopPropagation();
    e.preventDefault();
  }

  var beforeSubmit = function() {
    $('#cloud-text-container').hide();
    $('#dialog').slideDown(1500);
    $('#submit').prop("disabled",true);
  }

  var uploadProgress = function(e) {
    $("#cloud-bar").width(parseInt(100*(e.loaded/ e.total)) + "%");
  }

  var complete = function(e) {
    var rep = JSON.parse(e.currentTarget.responseText);
    $('#cloud-text').css('color', 'white');
    $('#cloud-text').css("font-size", "18px");
    if(rep.error_code != 0) {
      $('#server_file_name').val("");
      $('#file_name').val("");
      $('#cloud-text').text("An error occured while uploading the file...");
      $('#submit').prop("disabled",true);
    } else {
      $('#server_file_name').val(rep.server_file_name);
      $('#file_name').val(rep.file_name);
      $('#cloud-text').text("You uploaded " + rep.file_name);
      $('#submit').prop("disabled",false);
    }

    str = $('#cloud-text').text();
    if(str.length > 70) {
      $('#cloud-text').text(str.substr(0,30) + "..." + str.substr(str.length - 30, str.length - 1));
    }
    $('#cloud-text-container').fadeIn(1000);
  }

  var uploadFile = function(file) {
    beforeSubmit();
    var fd = new FormData();
    fd.append('file', file );
    var xhr = new XMLHttpRequest();
    xhr.upload.addEventListener("progress", uploadProgress);
    xhr.addEventListener("loadend", complete);
    xhr.open("POST", "upload_file.php");
    xhr.send(fd);
  }

  /*
    DRAG AND DROP
  */

	//block drag and drop on others part
	$(document).on('drop',preventDefault);
	$(document).on('dragenter',preventDefault);
	$(document).on('dragover', preventDefault);

	$("#fileSelect").on('dragenter', preventDefault);
	$("#fileSelect").on('dragover', preventDefault);
	$("#fileSelect").on('drop', function (e){
		var files = e.originalEvent.dataTransfer.files;
		uploadFile(files[0]);
	});

	/*
		UPLOAD FILE FORM
	*/

	// cloud reactions
	$('#fileSelect').click(function(e) {
	  $('#fileElem').click();
  });

  // form submission
	$("#formUpload").change(function(e) {
		uploadFile($("#fileElem")[0].files[0]);
	});

  /*
  	DIALOG FORM
  */

  // Form reactions

  $('#selection_all').on('click', function() {
    $('.from_to').slideUp('slow');
    $('#selection_selected').prop("checked", false);
  });

  $('#selection_selected').on('click', function() {
    $('.from_to').slideDown('slow');
    $('#selection_all').prop("checked", false);
  });

  $("#from").on("change", function() {
    var v = $("#from").val();
    if(v !== parseInt(v)) {
      $("#to").prop("min", v);
      if($("#to").val() < v) {
        $("#to").val(v);
      }
    }
  });

  // Form submission

	var options_dialog = {
		beforeSubmit: function(arr, $form, options) {
			$("#error").hide(0);
		  $("#error").html("Form could not be validated :<br/><ul></ul>");
      $("#print-result").hide(0);

		  var error = false;

		  if($("#user").val() === "") {
			  $("#error ul").append('<li>User field is empty</li>');
		  	error = true;
		  }

	  	if($("#password").val() === "") {
	  		$("#error ul").append('<li>Password field is empty</li>');
	  		error = true;
	  	}

		  if(parseInt($("#from").val()) > parseInt($("#to").val())) {
		  	$("#error ul").append('<li>Wrong page numbers</li>');
			  error = true;
		  }

		  if(error) {
		  	$("#error").show(0);
		  }

		  return ! error;
  	},

  	complete: function(response) {
	  	var rep = JSON.parse(response.responseText);
	  	if(rep.error_code == 0) {
	  		$("#print-result").text("The document was successfully printed.");
	  		$("#print-result").removeClass("alert-danger").addClass("alert-success");
	  		$("#print-result").show(0);
	  		setTimeout("location.reload()", 2000);
	  	} else {
        if(rep.error_code == 1000) {
          $("#print-result").text("Please verify your credentials...");
        } else {
          $("#print-result").text("An error occured while printing the document...");
        }
	  		$("#print-result").removeClass("alert-success").addClass("alert-danger");
	  		$("#print-result").show(0);
	  	}
	  }
	}

	$("#dialog-form").submit(function(event) {
		event.preventDefault();
		$(this).ajaxSubmit(options_dialog);
	});

});
