mongoose = require('../mongoose')
entry = require('./entry')

categorySchema = exports.Schema = new mongoose.Schema
  name: String
  entries: [entry.Schema]
  voted: [String]

categorySchema.methods.voted_on_by = (user) ->
  return false if user.kiosk

  for email in this.voted
    return true if email is user.email

  return false
