sendPrint = ->
  form = $('#printForm').validate()
  unless form['error']
    $('#printButton').addClass('_disabled')
    $.ajax 'php/print.php',
      type: "POST"
      data: form
      success: (response) ->
        rep = try JSON.parse(response) catch exeption then 'error_code' : -1
        switch rep['error_code']
          when 0
            n = files.length
            clearFileList()
            $('#printButton').addClass('_disabled')
            message('The document' + (if n > 1 then 's were' else ' was') + ' sent to the printer')
            showUpload()
          when 2
            message('A problem occured with dropbox')
          else
            message('An error occured while printing the document...')
      error: ->
        message('An error occured while printing the document...')

$(document).ready ->
  $('#printButton').click sendPrint
