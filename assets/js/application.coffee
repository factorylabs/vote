$ ->
  if $('.done').length is 1
    $('.vote').click (e) ->
      e.preventDefault()
      $(@)
        .addClass('selected').removeClass('dim')
        .siblings('.vote')
          .addClass('dim').removeClass('selected')

    $('.done').one 'click', (e) ->
      e.preventDefault()

      selected_entries = []
      selected_entries.push $(entry).data() for entry in $('.entry.selected')

      $.post '/vote', votes: selected_entries, (response) ->
        if response is 'OK'
          window.location = ''
        else
          alert('Damn. It\'s broke. Refresh.')
