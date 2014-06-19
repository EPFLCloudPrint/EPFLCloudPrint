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

  form.find('input').each (e) ->
    e.removeClass('_error')

  form.find('input').each (e) ->
    if not e.hasClass('_numberField')
      if e.hasClass('nonempty') and $(this).val() is ""
        result['error'] = true
        showError e
      else 
        result[e.attr('name')] = e.val()

  form.find('._checkbox').each (e) ->
    result[e.attr('name')] = e.hasClass('_checked')

  form.find('._numberField').each (e) ->
    if value = parseInt(e.val()) and (not e.attr('min') or value >= parseInt(e.attr('min'))) and (not e.attr('max') or value <= parseInt(e.attr('max')))
      result[e.attr('name')] = value
    else
      showError e
      result['error'] = true

  form.find('._radioGroup').each (g) ->
    result[g.attr('name')] = g.find('._radiobox._checked').attr('name');

  result

$ ->

  $('._checkbox').click ->
    event.preventDefault()
    if $(this).hasClass('_checked')
      $(this).removeClass('_checked').addClass('_unchecked')
    else
      $(this).removeClass('_unchecked').addClass('_checked')
    $(this).trigger('valueChanged')

  $('._radiobox').click ->
    event.preventDefault()
    if $(this).hasClass('_unchecked')
      $(this).parents('._radioGroup').children('._radiobox').removeClass('_checked').addClass('_unchecked')
      $(this).removeClass('_unchecked').addClass('_checked')
      $(this).parents('._radioGroup').trigger('valueChanged')

  $('._label').click ->
    event.preventDefault()
    $('.' + $(this).attr('for')).click()

  $('form').attr('onSubmit', "return false")

  $('.submit._button').click ->
    $(this).parents('form').submit()

  $('input._numberField').change ->
    $(this).check()

  