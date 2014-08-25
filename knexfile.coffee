config = require('./config')

module.exports =
  development:
    client: 'postgresql'
    connection:
      database: 'vote'
      user:     ''
      password: ''
    migrations:
      tableName: 'knex_migrations'

  staging:
    client: 'postgresql'
    connection:
      database: 'my_db'
      user:     'username'
      password: 'password'
    pool:
      min: 1
      max: 10
    migrations:
      tableName: 'knex_migrations'

  production:
    client: 'postgresql'
    connection:
      database: 'my_db'
      user:     'username'
      password: 'password'
    pool:
      min: 1
      max: 10
    migrations:
      tableName: 'knex_migrations'
