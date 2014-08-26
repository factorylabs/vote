module.exports = (bookshelf) ->
  User = bookshelf.Model.extend
    tableName: 'users'
    is_admin: -> true
  return User
