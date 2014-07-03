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
  removeFileServer files[id]['server_file_name']
  files = (file for file, index in files when index isnt id)
  $(this).parent('li').slideUp 'very slow', -> $(this).remove()
  if files.length is 0
    $("#tickPath").hide()
    showUpload()
  else if files.length is 1
    toggleSelection()

removeFileServer = (server_file_name) ->
  $.post 'php/remove_file.php', { 'server_file_name': server_file_name }

clearFileList = ->
  $('#fileList').slideUp().html('').slideDown()
  removeFileServer f['server_file_name'] for f in files 
  files = []

uploadFiles = (files) ->
  $('#printButton').addClass('_disabled')
  fd = new FormData()
  fd.append 'file[]', f for f in files
  xhr = new XMLHttpRequest()
  xhr.upload.addEventListener "progress", (e) ->
    updateProgression(e.loaded, e.total)
  xhr.addEventListener "loadend", (e) -> 
    $('.formUpload')[0].reset()
    rep = try JSON.parse(e.currentTarget.responseText) catch e then {'error_code' : -1}
    if rep['error_code'] is 0
      $('#cloudPath').attr('fill', 'white')
      $('#tickPath').show()
      for f in rep['files']
        addFile f if f.file_name isnt null and f.server_file_name isnt ""
      $('#printButton').removeClass('_disabled')
    else
      $("#tickPath").hide()
      $('#cloudPath').attr('fill', 'white')
      message('An error occured, please retry...')
      clearFileList()
      showUpload()

  xhr.open "POST", "php/upload_file.php"
  xhr.send(fd)
  showPrint()
