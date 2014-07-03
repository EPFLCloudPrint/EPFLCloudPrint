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
            setTimeout (-> $('#tickPath').hide()), 5000
            showUpload()
          when 2
            showError('A problem occured with dropbox')
          else
            showError('An error occured while printing the documents...')
      error: ->
        showError('An error occured while printing the documents...')

$(document).ready ->
  $('#printButton').click sendPrint

showError = (m) -> 
  $('#tickPath').hide()
  message(m)
  clearFileList();
  showUpload();
