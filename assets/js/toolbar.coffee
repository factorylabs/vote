#
# Main logo app dropdown on hover
#
# Bootstrap doesn't have a hover dropdown menu.
# Still using their classes, but not the data-toggle attr.
#
hoverdrop_menu =
  setup: ($elem) ->
    @$elem = $elem
    @$menu = @$elem.find('ul.dropdown-menu')

    @setup_main_nav()

    @$elem
      .mouseenter =>
        @$elem.addClass('open') unless @is_open()
      .mouseleave =>
        @$elem.removeClass('open')

  setup_main_nav: ->
    @get_main_nav_items (response) =>
      @organize_spreadsheet_entries(response.feed.entry)

  get_main_nav_items: (callback) ->
    spreadsheet_key = '0AgccpHEQlCxGdDB6T3hxX2IxM0o0SHdRaThBSmF2d0E'
    spreadsheet_api_url = "https://spreadsheets.google.com/feeds/cells/#{spreadsheet_key}/od6/public/basic?alt=json-in-script"

    $.getJSON(spreadsheet_api_url + '&callback=?', callback)

  organize_spreadsheet_entries: (entries) ->
    cells = []

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
        links_html += "<li><a href=\"#{link.url}\" target=\"_blank\">#{link.name}</a></li>"

    @$menu.html(links_html)

  is_open: -> @$elem.hasClass 'open'

$ ->
  hoverdrop_menu.setup($('.navbar-header .dropdown'))
