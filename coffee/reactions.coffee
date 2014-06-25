# PAGE DISPOSITION

centerCloud = ->
  if $('div.container').width() >= 768
    h = Math.max 0, ($('.container').height() - 70 - $('#cloudPicture').height()) / 2
    $('#cloud').css('margin-top', h)
  else
    $('#cloud').css('margin-top', 0)

centerDialog = ->
  if $('.container').width() >=  768
    h = Math.max 0, ($('div.container').height() - 40 - $('#dialog').height()) / 2
    $('#dialog').css('margin-top', h)
  else
    $('#dialog').css('margin-top', 0)


$(document).ready ->
  centerCloud()
  centerDialog()
  $(window).resize -> 
    centerCloud()
    centerDialog()

message = (m) ->
  $('#message').html(m).slideDown 1000, -> setTimeout (-> $('#message').slideUp 1000), 3000

# TOGGLE MODE

toggleSelectedOnly = ->
  if $('.selectedonly').hasClass('_checked')
    $('.fromto').slideDown centerDialog
    $('.from._numberField').val("")
    $('.to._numberField').val("")
  else
    $('.fromto').slideUp centerDialog

toggleSelection = ->
  $('.all._radiobox').click()
  if files.length == 1
    $('._radioGroup.selection').slideDown centerDialog
  else
    $('._radioGroup.selection').slideUp centerDialog

showUpload = ->
  if $('.options').css('display') is 'none'
    $('.options').slideUp -> $('#buttonWrapper').slideDown centerDialog
    $('.formUpload')[0].reset()

showPrint = ->
  $('#buttonWrapper').slideUp -> $('.options').slideDown centerDialog
  

# DRAG AND DROP 

wasTicked = false

$(document).ready ->

  $(document.body).bind "dragover", (e) ->
    e.preventDefault()
    false

  $(document.body).bind "drop", (e) ->
    e.preventDefault()
    false

  $('#cloudPath').bind "dragenter", ->
    wasTicked = ($('#tickPath').css('display') is not 'none')
    $('#tickPath').hide()
    $('#arrowPath').css 'fill', '#34495e'
    $('#arrowPath').css 'stroke', '#34495e'

  $('#cloudPath').bind "dragleave", ->
    $('#tickPath').show() if wasTicked
    $('#arrowPath').css('fill', 'none')
    $('#arrowPath').css('stroke', 'none')

  $('#cloudPath').bind "drop", (e) ->
    $('#cloudPath').trigger('dragleave') 
    files = e.originalEvent.target.files || e.originalEvent.dataTransfer.files
    uploadFile file for file in files when file.type is "application/pdf"

  $('#uploadButton').bind "dragenter", -> $(this).addClass 'drop'
  $('#uploadButton').bind "dragleave", -> $(this).removeClass 'drop'

  $('#uploadButton').bind "drop", (e) ->
    $('#uploadButton').trigger('dragleave') 
    files = e.originalEvent.target.files || e.originalEvent.dataTransfer.files
    uploadFile file for file in files when file.type is "application/pdf"

# BINDING ACTIONS AND START

$(document).ready ->
  $('.logout').click -> location.replace 'tequila/logout.php'
  $('#cloudPath').click -> $('.fileInput').click()
  $('#uploadButton').click -> $('.fileInput').click()
  $('form.formUpload').change -> uploadFile file for file in $(".fileInput")[0].files
  $('.selection._radioGroup').bind 'valueChanged', toggleSelectedOnly
  $('.from').change ->
    $('.to').attr 'min', $('.from').val
    $('.to').check()
