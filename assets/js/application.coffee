$ ->
  voting = $('#contest').length > 0

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
          alert 'voted!'
        .error ->
          alert 'error'
