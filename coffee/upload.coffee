files = []

addFile = (file) -> 
  files.push file    
  name = if file.file_name.length < 40 then file.file_name else file.file_name[..17] + "..." + file.file_name[-10...]
  $('#fileList').append "<li style='display: none;'>
          <img class='cancel' src='images/cancel.png' alt='remove file'/>
          " + name + 
          "</li>"
  $('#fileList li').slideDown('very slow')
  toggleSelection()
  $('.cancel').unbind('click').click removeFile

removeFile = ->
  id = $('li').index($(this).parent('li'))
  f = files.splice id, 1
  removeFileServer f[0].server_file_name
  $(this).parent('li').slideUp 'very slow', -> $(this).remove()
  if files.length is 0
    showUpload()
    $("#tickPath").hide()
  else if files.length is 1
    toggleSelection()

removeFileServer = (server_file_name) ->
  $.post 'php/remove_file.php', { 'server_file_name': server_file_name }

clearFileList = ->
  $('#fileList').slideUp().html('').slideDown()
  removeFileServer f['server_file_name'] for f in files 
  files = []

uploadFile = (file) ->
  $('#printButton').addClass('_disabled')
  fd = new FormData()
  fd.append 'file', file
  xhr = new XMLHttpRequest()
  xhr.addEventListener "loadend", (e) -> 
    rep = try JSON.parse(e.currentTarget.responseText) catch e then {'error_code' : -1}
    if rep['error_code'] == 0
      $("#tickPath").show()
      addFile {
        file_name: rep['file_name']
        server_file_name: rep['server_file_name']
      }
      $('#printButton').removeClass('_disabled')
    else
      $("#tickPath").hide()
      message('An error occured, please retry...')
      showUpload()

  xhr.open "POST", "php/upload_file.php"
  xhr.send(fd)
  showPrint()
