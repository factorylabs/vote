exports.up = (knex, Promise) ->
  knex.schema.table 'votes', (table) ->
    table.integer('contest_id')

exports.down = (knex, Promise) ->
  knex.schema.table 'votes', (table) ->
    table.dropColumn('contest_id')
