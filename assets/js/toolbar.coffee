#
# Main logo app dropdown on hover
#
# Bootstrap doesn't have a hover dropdown menu.
# Still using their classes, but not the data-toggle attr.
#
hoverdrop_menu =
  is_open: -> @$parent.hasClass 'open'

  hover: ->
    unless @is_open()
      @$parent.addClass 'open'

  hoverout: ->
    @$parent.removeClass 'open'

  setup: ($elem) ->
    @$parent = $elem.parents 'li'
    @$menu = @$parent.find 'ul.dropdown-menu'

    $elem
      .mouseenter => @hover()
      .mouseleave => @hoverout()
    @$menu.mouseleave => @hoverout()

$ ->
  hoverdrop_menu.setup $ '.logo'
