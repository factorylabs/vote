#
# Main logo app dropdown on hover
#
# Bootstrap doesn't have a hover dropdown menu.
# Still using their classes, but not the data-toggle attr.
#
hoverdrop_menu =
  setup: ($elem) ->
    @setup_main_nav()

    @$parent = $elem.parents('li')
    @$menu = @$parent.find('ul.dropdown-menu')

    $elem
      .mouseenter => @hover()
      .mouseleave => @hoverout()
    @$menu.mouseleave => @hoverout()

  setup_main_nav: ->
    @get_main_nav_items (response) =>
      @organize_spreadsheet_entries(response.feed.entry)

  get_main_nav_items: (callback) ->
    spreadsheet_key = '0AgccpHEQlCxGdDB6T3hxX2IxM0o0SHdRaThBSmF2d0E'
    spreadsheet_api_url = "https://spreadsheets.google.com/feeds/cells/#{spreadsheet_key}/od6/public/basic?alt=json-in-script"

    $.getJSON(spreadsheet_api_url + '&callback=?', callback)

  organize_spreadsheet_entries: (entries) ->
    cells = []#new Array(entries.length/2)

    for entry in entries
      cell_name = entry.title.$t # i.e. C4
      column = cell_name.charAt(0)
      position = +cell_name.slice(1)-1
      cell_content = entry.content.$t

      cells[position] ||= {}
      cells[position][if column is 'A' then 'name' else 'url'] = cell_content

    @populate_links(cells)

  populate_links: (links) ->
    links_html = ''

    for link in links
      if link.name is '-'
        links_html += '<li class="divider"></li>'
      else
        links_html += "<li><a href=\"#{link.url}\">#{link.name}</a></li>"

    $('#main-nav').html(links_html)

  is_open: -> @$parent.hasClass 'open'

  hover: ->
    @$parent.addClass('open') unless @is_open()

  hoverout: ->
    @$parent.removeClass('open')

$ ->
  hoverdrop_menu.setup($('.logo'))
