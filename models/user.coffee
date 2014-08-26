module.exports = (bookshelf) ->
  User = bookshelf.Model.extend
    tableName: 'users'
  return User
