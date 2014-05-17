var globalFile = "";

$(document).ready(function(){

	// Radio buttons : page selection
  $('#selection_all').on('click', function() {
    $('.from_to').slideUp('slow');
		$('#selection_selected').prop("checked", false);
	});

	$('#selection_selected').on('click', function() {
		$('.from_to').slideDown('slow');
		$('#selection_all').prop("checked", false);
	});

	// Fields : From and to
	$("#from").on("change", function() {
		var v = $("#from").val();
		if(v !== parseInt(v)) {
			$("#to").prop("min", v);
			if($("#to").val() < v) {
				$("#to").val(v);
			}
		}
	});

	/*
		UPLOAD FILE FORM
	*/

	// cloud reactions
	$('#fileSelect').click(function(e) {
	  $('#fileElem').click(); 
	  $('#dialog').slideUp(250);
	  $('.alert').hide(0);
  });

	$("#formUpload").change(function(e) {
		$("#formUpload").submit();
	});

	// submit settings
  var options_upload = {
  	beforeSubmit: function(arr, $form, options) { 
		  $('#cloud-text-container').hide();
		  $('#dialog').slideDown(1500);
  	},

	  uploadProgress: function(event, position, total, percentComplete) {
		  $("#cloud-bar").width(percentComplete + "%");
	  },
  
	  success: function() {
	  	$("#cloud-bar").width("100%");
	  },

	  complete: function(response) {
	  	var rep = JSON.parse(response.responseText);
	  	$('#cloud-text').css('color', 'white');
	  	$('#cloud-text').css("font-size", "18px");
	  	if(rep.error_code != 0) {
	  	  $('#cloud-text').text("An error occured while uploading the file...");
	  	} else {
	  	  $('#server_file_name').val(rep.server_file_name);
	  	  $('#cloud-text').text("You uploaded " + rep.file_name);
	  	  $('#cloud-text-container').fadeIn(500);
	  	}
	  }
  };

  // bind actions to send form
	$("#formUpload").submit(function(event){ 
		$(this).ajaxSubmit(options_upload);
		event.preventDefault();
	});

  /*
  	DIALOG FORM
  */

	var options_dialog = {
		beforeSubmit: function(arr, $form, options) { 
			$("#error").hide(0);
		  $("#error").html("Form could not be validated :<br/><ul></ul>");

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
	  		$("#print-result").text("An error occured while printing the document...");
	  		$("#print-result").removeClass("alert-success").addClass("alert-danger");
	  		$("#print-result").show(0);
	  	}
	  }
	}

	// submit dialog results
	$("#dialog-form").submit(function(event) {
		event.preventDefault();
		$(this).ajaxSubmit(options_dialog);
	});
});
