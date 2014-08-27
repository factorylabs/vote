module.exports = (bookshelf) ->
  Entry = bookshelf.Model.extend
    tableName: 'entries'
  return Entry
