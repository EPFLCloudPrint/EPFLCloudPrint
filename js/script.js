var globalFile = "";

$(document).ready(function(){

	//mobile profiling
	var w = $(window).width();
	if(w < 800 && w > 400)
	{
		$('#bigcontainer').width(w-40);
	}
	else if(w<= 400)
	{
		$('#bigcontainer').width(400);
	}

// do form hiding and event listening
	$('#container').hide();

	$("#formUpload").change(function(e){
		$("#formUpload").submit();
		$('#cloud-text-container').hide();
		$('#container').slideDown(1500);
	});

	$('#fileSelect').click(function(e) {
	// Use the native click() of the file input.
	$('#fileElem').click();


	//drag and drop attempt starts here
	var obj = $("#fileSelect");
	obj.on('dragenter', function (e)
	{
		e.stopPropagation();
		e.preventDefault();
	});
	obj.on('dragover', function (e)
	{
		e.stopPropagation();
		e.preventDefault();
	});
	obj.on('drop', function (e)
	{
		e.preventDefault();
		var files = e.originalEvent.dataTransfer.files;

		//We need to send dropped files to Server
		$('#fileElem').value = files[0];
		//$('#formUpload').append('file',files[0]).submit();
	});
	//===================================

	$('.double_sided').click(function() {
		$('.myCheckbox').prop('checked', false);
	});

	$('.selection_all').on('click', function() {
		$('.from_to').hide('slow');
		$('.selection_all').checkbox('enable');
		$('.selection_selected').checkbox('disable');
		$('.from_to input').val("");
	});

	$('.selection_selected').on('click', function() {
		$('.from_to').show('slow');
		$('.selection_selected').checkbox('enable');
		$('.selection_all').checkbox('disable');
	});

	$('.selection_all').checkbox('enable');
	$('.double_sided').checkbox();
	$('.copies.input').val(1);

	$('.ui.form.segment')
	.form({
		user: {
			identifier  : 'user',
			rules: [
			{
				type   : 'empty',
				prompt : 'Please enter a username'
			}
			]
		},
		password: {
			identifier : 'password',
			rules: [
			{
				type   : 'empty',
				prompt : 'Please enter a password'
			},
			{
				type   : 'length[6]',
				prompt : 'Your password must be at least 6 characters'
			}
			]
		},
		from : {
			identifier : "from"
		},
		to : {
			identifier : "to"
		},
		copies : {
			identifier : "copies"
		},
		double_sided : {
			identifier : "double_sided"
		}
	})


});

var options = {
	beforeSend: function()
	{

	},
	uploadProgress: function(event, position, total, percentComplete)
	{
		$("#cloud-bar").width(percentComplete + "%");

	},
	success: function()
	{
		$("#cloud-bar").width("100%");

	},
	complete: function(response)
	{
		$('#hiden_field_file').val(response.responseText);
		$('#cloud-text').css('color', 'white');
		$('#cloud-text').css("font-size", "18px");
		$('#cloud-text').text("You uploaded " + response.responseText);
		$('#cloud-text-container').fadeIn(1000);
	},
	error: function()
	{
	}

};

$("#formUpload").ajaxForm(options);

});
