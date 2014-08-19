settings =
  port: process.env.PORT or 8080
  onelogin_url: if process.env.NODE_ENV isnt 'production' then 'https://app.onelogin.com/launch/387371' else 'https://app.onelogin.com/launch/387372'
  onelogin_token: if process.env.NODE_ENV isnt 'production' then 'foobar' else '01accf4f-cc47-4035-8d47-bf8f9b163a5c'

module.exports = settings
