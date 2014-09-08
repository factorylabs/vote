$ ->
  voting = $('#contest').length > 0

  if voting
    $('.entry a.thumbnail').click ->
      $entry = $(@).parent('.entry')

      $entry.addClass('selected')
      $entry.siblings().removeClass('selected')
