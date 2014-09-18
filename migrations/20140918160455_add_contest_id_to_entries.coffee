exports.up = (knex, Promise) ->
  knex.schema.table 'entries', (table) ->
    table.integer('contest_id')

exports.down = (knex, Promise) ->
  knex.schema.table 'entries', (table) ->
    table.dropColumn('contest_id')
