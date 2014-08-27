module.exports = (bookshelf) ->
  Vote = bookshelf.Model.extend
    tableName: 'votes'
    hasTimestamps: true

    user: ->
      @belongsTo('User', 'user_id')

    entry: ->
      @belongsTo('Entry', 'entry_id')

  return Vote
