module.exports = (bookshelf) ->
  Contest = bookshelf.Model.extend
    tableName: 'contests'
    hasTimestamps: true

    categories: ->
      @hasMany('Category', 'contest_id')

    entires: ->
      @hasMany('Entry', 'contest_id')

    votes: ->
      @hasMany('Vote', 'contest_id')

    already_voted_by: (user) ->
      return false if user.is_admin()

      voted = false
      for vote in @related('votes').toJSON()
        if vote.user_id is user.id
          voted = true
          break
      return voted

  return Contest
