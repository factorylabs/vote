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
      voted = false
      for vote in @related('votes').toJSON()
        console.log vote.user_id
        if vote.user_id is user.id
          console.log 'found a vote'
          voted = true
          break
      return voted

  return Contest
