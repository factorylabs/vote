mongoose = require('../mongoose')

userSchema = mongoose.Schema
  name: String
  email: String
  openId: String

User = module.exports.Model = mongoose.model('User', userSchema)

User.schema.path('email').validate((value) ->
  /@factorylabs.com+/i.test(value)
, 'Not a FDL email!')
