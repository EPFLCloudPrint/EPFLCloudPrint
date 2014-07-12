# PAGE DISPOSITION

centerCloud = ->
  if $('div.container').width() >= 768
    h = Math.max 0, ($('.container').height() - 60 - $('#cloudPicture').height()) / 2
    $('#cloud').css('margin-top', h)
  else
    $('#cloud').css('margin-top', 0)

centerDialog = ->
  if $('.container').width() >=  768
    h = Math.max 0, ($('div.container').height() - 40 - $('#dialog').height()) / 2
    $('#dialog').css('margin-top', h)
  else
    $('#dialog').css('margin-top', 0)

message = (m) ->
  $('#message').html(m).slideDown 1000, -> setTimeout (-> $('#message').slideUp 1000), 3000

# TOGGLE MODE

toggleSelectedOnly = ->
  if $('.selectedonly').hasClass('_checked')
    $('.fromto').slideDown()
    $('.from._numberField').val("")
    $('.to._numberField').val("")
  else
    $('.fromto').slideUp()

toggleSelection = ->
  $('.all._radiobox').click()
  if files.length == 1
    $('._radioGroup.selection').slideDown centerDialog
  else
    $('._radioGroup.selection').slideUp centerDialog

showUpload = ->
  $('.options').slideUp -> $('#buttonWrapper').slideDown centerDialog
  $('.formUpload')[0].reset()

showPrint = ->
  $('#buttonWrapper').slideUp(-> $('.options').slideDown(centerDialog))

updateProgression = (loaded, total) ->
  $('#tickPath').hide()
  $('#cloudPath').attr('fill', 'url(#progression)')
  $('#progression stop').attr 'offset', loaded / total * 100 + "%"

# DRAG AND DROP

wasTicked = false

$(document).ready ->

  $(document.body).bind "dragover drop", (e) ->
    e.preventDefault()
    false

  $('#cloudPath').bind "dragenter", (e) ->
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
    uploadFiles(files)

  $('#uploadButton').bind "dragenter dragover", -> $(this).addClass 'drop'
  $('#uploadButton').bind "dragleave", -> $(this).removeClass 'drop'

  $('#uploadButton').bind "drop", (e) ->
    $('#uploadButton').trigger('dragleave')
    files = e.originalEvent.target.files || e.originalEvent.dataTransfer.files
    uploadFiles(files)

# BINDING ACTIONS AND START

$(document).ready ->
  $('.logout').click -> location.replace 'tequila/logout.php'
  $('#cloudPath').click -> $('.fileInput').click()
  $('#uploadButton').click -> $('.fileInput').click()
  $('form.formUpload').change -> uploadFiles $(".fileInput")[0].files
  $('.selection._radioGroup').bind 'valueChanged', toggleSelectedOnly
  $('.from').change ->
    $('.to').attr 'min', $('.from').val
    $('.to').check()
  centerCloud()
  centerDialog()
  $(window).resize ->
    centerCloud()
    centerDialog()
  setTimeout -> $('#cloud, #dialog').css 'transition', 'margin-top 1s'
