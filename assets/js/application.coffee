$ ->
  $('[rel=popover]').popover
    trigger: 'hover'
    html: true

  $('.vote').click (e) ->
    e.preventDefault()
    $(@).parent('li.entry').addClass('selected').removeClass('dim').siblings('li').addClass('dim').removeClass('selected')

  $('.done').one 'click', (e) ->
    e.preventDefault()

    selected_entries = []
    selected_entries.push $(entry).data() for entry in $('.entry.selected')

    $.post '/vote', votes: selected_entries, (response) ->
      if response is 'OK'
        window.location = ''
      else
        alert('Damn. It\'s broke. Refresh')
