module.exports = (bookshelf) ->
  Vote = bookshelf.Model.extend
    tableName: 'votes'
  return Vote
