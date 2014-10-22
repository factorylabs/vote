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

  production:
    client: 'postgresql'
    connection: config.pg_connection_string
    migrations:
      tableName: 'knex_migrations'
