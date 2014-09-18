module.exports = (bookshelf) ->
  Contest = bookshelf.Model.extend
    tableName: 'contests'
    hasTimestamps: true

    categories: ->
      @hasMany('Category', 'contest_id')

    entires: ->
      @hasMany('Entry', 'contest_id')

    votes: ->
      @hasMany('Vote', 'contest_id')

  return Contest
