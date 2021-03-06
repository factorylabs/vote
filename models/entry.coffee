module.exports = (bookshelf) ->
  Entry = bookshelf.Model.extend
    tableName: 'entries'
    hasTimestamps: true

    contest: ->
      @belongsTo('Contest', 'contest_id')

    category: ->
      @belongsTo('Category', 'category_id')

    votes: ->
      @hasMany('Vote', 'entry_id')

  return Entry
