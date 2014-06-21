# PAGE DISPOSITION

centerCloud = ->
  if $('div.container').width() >= 768
    h = Math.max 0, ($('.container').height() - 70 - $('#cloud_column .foreground').height()) / 2
    $('#cloud_column').css('margin-top', h)
  else
    $('#cloud_column').css('margin-top', 0)

centerDialog = ->
  if $('.container').width() >=  768
    h = Math.max 0, ($('div.container').height() - 40 - $('div.dialog').height()) / 2
    $('.dialog').css('margin-top', h)
  else
    $('.dialog').css('margin-top', 0)


$(document).ready ->
  centerCloud()
  centerDialog()
  $(window).resize -> 
    centerCloud()
    centerDialog()

message = (m) ->
  $('.message').html(m)

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
  $('.options').slideUp -> $('#button_wrapper').slideDown centerDialog
  $('.formUpload')[0].reset()

showPrint = ->
  $('#button_wrapper').slideUp -> $('.options').slideDown centerDialog
  

# DRAG AND DROP 

wasTicked = false

$(document).ready ->

  $(document.body).bind "dragover", (e) ->
    e.preventDefault()
    false

  $(document.body).bind "drop", (e) ->
    e.preventDefault()
    false

  $('#cloud_path').bind "dragenter", ->
    wasTicked = ($('#tick_path').css('display') is not 'none')
    $('#tick_path').hide()
    $('#arrow_path').css 'fill', '#34495e'
    $('#arrow_path').css 'stroke', '#34495e'

  $('#cloud_path').bind "dragleave", ->
    $('#tick_path').show() if wasTicked
    $('#arrow_path').css('fill', 'none')
    $('#arrow_path').css('stroke', 'none')

  $('#cloud_path').bind "drop", (e) ->
    $('#cloud_path').trigger('dragleave') 
    files = e.originalEvent.target.files || e.originalEvent.dataTransfer.files
    uploadFile file for file in files when file.type is "application/pdf"

  $('.upload._button').bind "dragenter", -> $(this).addClass 'drop'
  $('.upload._button').bind "dragleave", -> $(this).removeClass 'drop'

  $('.upload._button').bind "drop", (e) ->
    $('.upload._button').trigger('dragleave') 
    files = e.originalEvent.target.files || e.originalEvent.dataTransfer.files
    uploadFile file for file in files when file.type is "application/pdf"

# BINDING ACTIONS AND START

$(document).ready ->
  $('.logout').click -> location.replace 'tequila/logout.php'
  $('#cloud_path').click -> $('.fileInput').click()
  $('.upload._button').click -> $('.fileInput').click()
  $('form.formUpload').change -> uploadFile file for file in $(".fileInput")[0].files
  $('.selection._radioGroup').bind 'valueChanged', toggleSelectedOnly
  $('.from').change ->
    $('.to').attr 'min', $('.from').val
    $('.to').check()
