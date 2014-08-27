module.exports = (bookshelf) ->
  Contest = bookshelf.Model.extend
    tableName: 'contests'
  return Contest
