sendPrint = ->
  form = $('#printForm').validate()
  unless form['error']
    form['gaspar'] = GASPAR
    form['files'] = files
    $('.print._button').addClass('_disabled')
    $.ajax 'print.php',
      type: "POST"
      data: form
      success: (response) ->
        rep = try JSON.parse(response) catch e then 'error_code' : -1
        switch rep['error_code']
          when 0
            message('The document' + (if files.length > 1 then 's were' else ' was') + ' sent to the printer')
            toggleTheUploadMode("UPLOAD NEW FILES")
          when 2
            message('A problem occured with dropbox')
          when 3
            showError($('.gaspar, .password'))
            message('Please check your credentials')
          else
            message('An error occured while printing the document...')
      error: ->
        message('An error occured while printing the document...')
      complete: ->
        files = []
        $('.print._button').removeClass('_disabled')

$ ->
  $('.print._button').click sendPrint