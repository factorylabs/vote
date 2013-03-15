$ ->
  $('[rel=popover]').popover
    trigger: 'hover'
    html: true

  $('.vote').one 'click', (e) ->
    e.preventDefault()
    $entry = $(@)
    entry_data = $entry.data()

    $.post '/vote', entry_data, (response) ->
      if response is 'OK'
        $entry.parent('li').siblings().addClass('dim').children('a').unbind('click')
        $entry.parents('.category-container').find('.category-message').text('You have already voted in this category.')
      else
        alert('Damn. It\'s broke. Refresh')
