exports.up = (knex, Promise) ->
  knex.schema.createTable 'entries', (table) ->
    table.increments()
    table.string('name')
    table.string('attachment')
    table.integer('category_id').notNullable()
    table.timestamps()

exports.down = (knex, Promise) ->
  knex.schema.dropTable('entries')
