exports.up = (knex, Promise) ->
  knex.schema.createTable 'contests', (table) ->
    table.increments()
    table.string('name').notNullable()
    table.boolean('open').defaultTo(true)
    table.timestamps()

exports.down = (knex, Promise) ->
  knex.schema.dropTable('contests')
