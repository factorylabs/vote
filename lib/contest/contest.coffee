mongoose = require('../mongoose')
entry = require('./entry')

contestSchema = new mongoose.Schema
  name: String
  entries: [entry.Schema]
  voted: [String]

contestSchema.methods.voted_on_by = (user) ->
  for email in this.voted
    return true if email is user.email
  return false

Contest = module.exports = mongoose.model('Contest', contestSchema)
