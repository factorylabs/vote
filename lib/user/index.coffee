mongoose = require('../mongoose')

userSchema = mongoose.Schema
  name: String
  email: String
  openId: String
  admin: {type: Boolean, default: false}

userSchema.methods.is_admin = ->
  console.log this.admin
  return this.admin

User = module.exports.Model = mongoose.model('User', userSchema)

User.schema.path('email').validate((value) ->
  /@factorylabs.com+/i.test(value)
, 'Not a FDL email!')
