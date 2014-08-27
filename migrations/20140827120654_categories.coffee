exports.up = (knex, Promise) ->
  knex.schema.createTable 'categories', (table) ->
    table.increments()
    table.string('name').notNullable()
    table.integer('contest_id').notNullable()
    table.timestamps()

exports.down = (knex, Promise) ->
  knex.schema.dropTable('categories')
