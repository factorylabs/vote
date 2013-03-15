$ ->
  $('.open-contest').change ->
    $checkbox = $(@)
    contest_id = $checkbox.data('contest')
    contest =
      open: $checkbox.prop('checked')

    $.post "/admin/contests/#{contest_id}", contest, (response) ->
      console.log response
