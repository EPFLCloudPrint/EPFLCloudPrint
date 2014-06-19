files = []

updateFilesList = ->
  $('.message').html("<ul id='files'></ul>")
  for f in files
    name = if name.length < 30 then file['file_name'] else file['file_name'][..14] + "..." + file['file_name'][-14...]
    $('#files').append("<li><span class='removeFile'>" + name + "</span></li>")

  if files.length > 1
    $('.all._radiobox').click()
    $('._radioGroup.selection').hide(centerDialog)
  else if $('._radioGroup.selection').css('display') is 'none'
    $('._radioGroup.selection').show centerDialog

  centerCloud()

  $('span.removeFile').click ->
    files.splice $(this).index(), 1
    if files.length is 0
      toggleTheUploadMode()
      $("#tick_path").hide
    updateFilesList()

uploadFile = (file) ->
  toggleThePrintMode()
  $('.print._button').addClass('_disabled')
  fd = new FormData()
  fd.append 'file', file
  xhr = new XMLHttpRequest()
  xhr.addEventListener "loadend", (e) -> 
    rep = try JSON.parse(e.currentTarget.responseText) catch e then {'error_code' : -1}
    if rep['error_code'] == 0
      $("#tick_path").show
      files.push 
        file_name: rep['file_name']
        server_file_name: rep['server_file_name']
      updateFilesList
      $('.print._button').removeClass('_disabled')
    else
      $("#tick_path").hide
      message('An error occured, please retry...')
      toggleTheUploadMode("UPLOAD YOUR FILES")

  xhr.open "POST", "upload_file.php"
  xhr.send(fd)