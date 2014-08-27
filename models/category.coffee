module.exports = (bookshelf) ->
  Category = bookshelf.Model.extend
    tableName: 'categories'
  return Category
