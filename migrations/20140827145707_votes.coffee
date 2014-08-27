exports.up = (knex, Promise) ->
  knex.schema.createTable 'votes', (table) ->
    table.increments()
    table.integer('user_id').notNullable()
    table.integer('entry_id').notNullable()
    table.timestamps()

exports.down = (knex, Promise) ->
  knex.schema.dropTable('votes')
