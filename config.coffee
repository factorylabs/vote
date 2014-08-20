settings =
  secret: '1a581d54eceb4b2f85b8992496cc43e4'
  port: process.env.PORT or 8080
  pg_connection_string: process.env.DATABASE_URL or 'postgres://localhost:5432/vote'
  onelogin_url: if process.env.NODE_ENV isnt 'production' then 'https://app.onelogin.com/launch/387371' else 'https://app.onelogin.com/launch/387372'
  onelogin_token: if process.env.NODE_ENV isnt 'production' then 'foobar' else '01accf4f-cc47-4035-8d47-bf8f9b163a5c'

module.exports = settings
