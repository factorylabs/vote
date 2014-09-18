module.exports = (bookshelf) ->
  User = bookshelf.Model.extend
    tableName: 'users'
    hasTimestamps: true

    votes: ->
      @hasMany('Vote', 'user_id')

    is_admin: ->
      return @admin if @admin?
      admins = [
        'taylor.beseda'
        'ryan.colley'
        'lindsey.ritter'
        'jon.poplar'
      ]
      user = @get('email').replace('@factorylabs.com','')
      return @admin = admins.indexOf(user) > -1

  return User
