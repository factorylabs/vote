mongoose = require('../mongoose')

userSchema = mongoose.Schema
  name: String
  email: String
  openId: String
  kiosk: {type: Boolean, default: false}
  admin: {type: Boolean, default: false}

userSchema.methods.is_admin = ->
  return @admin

userSchema.methods.vote = (entry, callback) ->
  user = @
  category = entry.parent()
  contest = category.parent()

  if category.voted_on_by(user)
    callback
      message: 'User already voted on category.'
      entry: entry
  else
    if entry?
      entry.votes++

      unless user.kiosk
        category.voted.push(user.email)

      contest.save (err) ->
        callback(err)

userSchema.methods.submit_votes = (votes, callback) ->
  user = @
  success = 0
  errors = []

  for vote in votes
    # votes are simple objects with contest, category, and entry ids
    do (vote) ->
      Contest.findById vote.contest, (err, contest) ->
        category = contest.categories.id(vote.category)
        entry = category.entries.id(vote.entry)

        user.vote entry, (err) ->
          errors.push err if err
          success++

          if success + errors.length == votes.length
            callback(errors)

User = module.exports.Model = mongoose.model('User', userSchema)

User.schema.path('email').validate((value) ->
  /@factorylabs.com+/i.test(value)
, 'Not a FDL email!')
