$ ->
  voting = $('#contest').length > 0 && $('#contest').data('id')

  if voting
    contest_id = $('#contest').data('id')

    $('.entry .thumbnail').click ->
      $entry = $(@).parent('.entry')

      $entry.parent().addClass('voting')
      $entry.addClass('selected')
      $entry.siblings().removeClass('selected')

    $('#submit-vote').one 'click', ->
      $selected_entries = $('.entry.selected')
      entries = []
      for entry in $selected_entries
        entries.push({id: $(entry).data('entry').id})

      $.post "/contests/#{contest_id}/vote", entries: entries
        .success ->
          window.location.reload(true)
        .error ->
          alert 'Error submitting vote. Refresh and try again.'
