models = require('../models')
Vote = models.vote

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

    vote_for: (entries, callback) ->
      votes = 0
      for entry in entries
        new_vote =
          entry_id: entry.id
          user_id: @get('id')

        Vote
          .forge(new_vote)
          .save()
          .then ->
            votes++
            callback() if votes is entries.length

  return User
