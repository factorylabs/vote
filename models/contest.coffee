module.exports = (bookshelf) ->
  Contest = bookshelf.Model.extend
    tableName: 'contests'
    hasTimestamps: true

    categories: ->
      @hasMany('Category', 'contest_id')
      
  return Contest
