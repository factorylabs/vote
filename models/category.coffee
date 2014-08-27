module.exports = (bookshelf) ->
  Category = bookshelf.Model.extend
    tableName: 'categories'
    hasTimestamps: true

    contest: ->
      @belongsTo('Contest', 'contest_id')

    entries: ->
      @hasMany('Entry', 'category_id')

  return Category
