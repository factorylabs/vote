config = require('../config')

module.exports = (bookshelf) ->
  User = bookshelf.Model.extend
    tableName: 'users'
    hasTimestamps: true

    votes: ->
      @hasMany('Vote', 'user_id')

    is_admin: ->
      return @admin if @admin?
      user = @get('email').replace('@factorylabs.com','')
      return @admin = config.admins.indexOf(user) > -1

  return User
