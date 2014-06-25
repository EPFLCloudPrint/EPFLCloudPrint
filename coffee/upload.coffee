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

loadingFiles = []

uploadFile = (file) ->
  $('#printButton').addClass('_disabled')
  fd = new FormData()
  fd.append 'file', file
  xhr = new XMLHttpRequest()
  id = loadingFiles.length
  loadingFiles.push { loaded: 0, total: 0 }
  xhr.upload.addEventListener "progress", (e) ->
    loadingFiles[id] = {loaded: e.loaded, total: e.total}
    updateProgression()
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

updateProgression = ->
  sums = loadingFiles.reduce (a, b) -> { loaded: a.loaded + b.loaded, total: a.total + b.total }
  if ( sums.loaded is sums.total ) and ( not loadingFiles.some((f) -> f.loaded is 0 or f.total is 0) )
    loadingFiles = []
    $('#tickPath').show()
    $('#cloudPath').attr('fill', 'white')
  else
    $('#tickPath').hide()
    $('#cloudPath').attr('fill', 'url(#progression)')
    $('#progression stop').attr 'offset', sums.loaded / sums.total * 100 + "%"
