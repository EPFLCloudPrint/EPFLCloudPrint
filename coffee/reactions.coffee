# PAGE DISPOSITION

centerCloud = ->
  if $('div.container').width() >= 768
    h = Math.max 0, ($('.container').height() - 45 - $('.cloud').height()) / 2
    $('.cloud').css('margin-top', h)
  else
    $('.cloud').css('margin-top', 0)

centerDialog = ->
  if $('.container').width() >=  768
    h = Math.max 0, ($('div.container').height() - 45 - $('div.dialog').height()) / 2
    $('.dialog').css('margin-top', h)
  else
    $('.dialog').css('margin-top', 0)

centerButtons = -> 
  switch $('.container').width()
    when 300
      $('.upload._button').css('margin-left', ($('.dialog').width() - $('.upload._button').width())/2)
      $('.dropbox._button').css('margin-left', ($('.dialog').width() - $('.dropbox._button').width())/2)
    when 420, 960
      $('.upload._button').css('margin-left', 0)
      $('.dropbox._button').css('margin-left', "10px")
    when 768
      $('.upload._button').css('margin-left', 0)
      $('.dropbox._button').css('margin-left', 0)

centerAll = -> 
  centerDialog()
  centerCloud()
  centerButtons()

centeringProcessing = []

startCentering = ->
  proc = setInterval centerAll, 10
  centeringProcessing.push proc

stopCentering = ->
  if centeringProcessing.length > 0
    clearInterval centeringProcessing.shift

message = (m) ->
  $('.message').html(m)
  centerCloud()

# TOGGLE MODE

toggleSelectionMode = ->
  startCentering()
  if $('.selectedonly').hasClass('_checked')
    $('.fromto').slideDown 'normal', stopCentering
    $('.from._numberField').val("")
    $('.to._numberField').val("")
  else
    $('.fromto').slideUp('normal', stopCentering)

toggleTheUploadMode = (buttonName) ->
  $('.options').hide()
  $('.formUpload')[0].reset()
  $('.upload._button').html buttonName
  $('._empty._button').show centerAll

toggleThePrintMode = ->
  startCentering()
  $('._empty._button').hide()
  $('.options').slideDown 1000, stopCentering

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
  centerAll()
  $(window).resize centerAll
  $('.logout').click -> location.replace 'tequila/logout.php'
  $('#cloud_path').click -> $('.fileInput').click()
  $('.upload._button').click -> $('.fileInput').click()
  $('form.formUpload').change -> uploadFile file for file in $(".fileInput")[0].files
  $('.from').change ->
    $('.to').attr 'min', $('.from').val
    $('.to').check()
  $('.selection._radioGroup').on 'valueChanged', toggleSelectionMode
