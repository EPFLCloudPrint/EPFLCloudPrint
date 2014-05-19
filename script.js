var globalFile = "";

function preventDefault(e){
	e.stopPropagation();
	e.preventDefault();
}

function beforeSubmit(){
	$('#cloud-text-container').hide();
	$('#dialog').slideDown(1500);
}

function uploadProgress(e){
	$("#cloud-bar").width(parseInt(100*(e.loaded/ e.total)) + "%");
}

function success(e){

}


function complete(e){
	var rep = JSON.parse(e.currentTarget.responseText);
	//console.log(e);
	$("#cloud-bar").width("100%");
	$('#hiden_field_file').val(rep.file_name);
	$('#cloud-text').css('color', 'white');
	$('#cloud-text').css("font-size", "18px");
	$('#cloud-text').text("You uploaded " + rep.file_name);
	$('#cloud-text-container').fadeIn(1000);
}

function uploadFile(file){
	var fd = new FormData();    
	fd.append( 'file', file );
	var xhr = new XMLHttpRequest();
	xhr.upload.addEventListener("progress", uploadProgress);
	xhr.addEventListener("loadend", complete);
	xhr.open("POST", "upload_file.php");
	xhr.send(fd);
	beforeSubmit();
}

$(document).ready(function(){

/*===============================================================
**************************DRAG AND DROP**************************
=================================================================*/
	//block drag and drop on others part
	$(document).on('drop',preventDefault);
	$(document).on('dragenter',preventDefault);
	$(document).on('dragover', preventDefault);

	var obj = $("#fileSelect");
	obj.on('dragenter', preventDefault);
	obj.on('dragover', preventDefault);
	obj.on('drop', function (e)
	{
		var files = e.originalEvent.dataTransfer.files;
		uploadFile(files[0]);
	});

/*===============================================================
************************END DRAG AND DROP************************
=================================================================*/


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
		uploadFile($("#fileElem")[0].files[0]);
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
