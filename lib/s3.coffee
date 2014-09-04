config = require('../config')
knox = require('knox')

module.exports = knox.createClient
  key: config.aws_key_id
  secret: config.aws_secret_key
  bucket: 'factory-vote'
