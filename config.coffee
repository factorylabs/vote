settings =
  secret: '1a581d54eceb4b2f85b8992496cc43e4'
  port: process.env.PORT or 8080
  pg_connection_string: process.env.DATABASE_URL or 'postgres://localhost:5432/vote'
  onelogin_url: if process.env.NODE_ENV isnt 'production' then 'https://app.onelogin.com/launch/394050' else 'https://app.onelogin.com/launch/394047'
  onelogin_token: if process.env.NODE_ENV isnt 'production' then 'foobar' else 'e2343142-ddee-400f-a3e1-cd410f0e32b6'

module.exports = settings
