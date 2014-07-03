# show error flag on field
showError = (field) ->
  field.addClass('_error')
  field.click (event) ->
    $(this).removeClass('_error')
    $(this).unbind(event)

# number field check
jQuery.fn.check = ->
  if $(this).hasClass('_numberField')
    min = $(this).attr('min')
    max = $(this).attr('max')
    def = $(this).attr('default')
    v = parseInt($(this).val()) || def || min || 1
    v = if v >= min then v else min
    $(this).val(v)

# form validation returning values
jQuery.fn.validate = ->
  result = {}
  form = $(this)

  form.find('input').each -> $(this).removeClass '_error'

  form.find('input._nonempty').each  ->
      if $(this).val() is ""
        result['error'] = true
        showError $(this)
      else
        result[$(this).attr('name')] = $(this).val()

  form.find('._checkbox').each ->
    result[$(this).attr('name')] = $(this).hasClass('_checked')

  form.find('._numberField').each ->
    result[$(this).attr('name')] = parseInt($(this).val())

  form.find('._radioGroup').each ->
    result[$(this).attr('name')] = $(this).find('._radiobox._checked').attr('name');

  result

$(document).ready ->
  $('._checkbox').click (event) ->
    event.preventDefault()
    if $(this).hasClass('_checked')
      $(this).removeClass('_checked').addClass('_unchecked')
    else
      $(this).removeClass('_unchecked').addClass('_checked')
    $(this).trigger('valueChanged')

  $('._radiobox').click (event) ->
    event.preventDefault()
    if $(this).hasClass('_unchecked')
      $(this).parents('._radioGroup').children('._radiobox').removeClass('_checked').addClass('_unchecked')
      $(this).removeClass('_unchecked').addClass('_checked')
      $(this).parents('._radioGroup').trigger('valueChanged')

  $('._label').click (event) ->
    event.preventDefault()
    $('.' + $(this).attr('for')).click()

  $('form').attr('onSubmit', "return false")

  $('.submit._button').click ->
    $(this).parents('form').submit()

  $('input._numberField').change ->
    $(this).check()
