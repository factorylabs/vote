exports.up = (knex, Promise) ->
  knex.schema.createTable 'users', (table) ->
    table.increments()
    table.string('name')
    table.string('email')
    table.timestamps()

exports.down = (knex, Promise) ->
  knex.schema.dropTable('users')
