fs = require('fs')

env = process.env.NODE_ENV or 'development'

config =
  env: env
  secret: '1a581d54eceb4b2f85b8992496cc43e4'
  port: process.env.PORT or 8080
  pg_connection_string: process.env.DATABASE_URL or 'postgres://localhost:5432/vote'
  onelogin_url: if env isnt 'production' then 'https://app.onelogin.com/launch/394047' else 'https://app.onelogin.com/launch/394050'
  onelogin_token: if env isnt 'production' then 'foobar' else 'e2343142-ddee-400f-a3e1-cd410f0e32b6'

config.db =
  client: 'pg'
  connection: config.pg_connection_string
  # debug: true

config = require('./env')(config) if fs.existsSync('./env.coffee')

module.exports = config
