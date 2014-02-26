$ ->
  $('#open-contest').change ->
    $checkbox = $(@)
    contest_id = $checkbox.data('contest')
    contest =
      open: $checkbox.prop('checked')

    $.post "/admin/contests/#{contest_id}", contest, (response) ->
      console.log response

  $('#show-results').change ->
    $checkbox = $(@)
    contest_id = $checkbox.data('contest')
    contest =
      show_results: $checkbox.prop('checked')

    $.post "/admin/contests/#{contest_id}", contest, (response) ->
      console.log response

  $('form.delete-entity').submit ->
    return confirm('Are you sure?')
