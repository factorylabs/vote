# according to https://github.com/voxpelli/node-connect-pg-simple/blob/master/table.sql

exports.up = (knex, Promise) ->
  knex.schema.createTable 'session', (table) ->
    table.string('sid').notNullable().primary()
    table.json('sess').notNullable()
    table.timestamp('expire').notNullable()

exports.down = (knex, Promise) ->
  knex.schema.dropTable('session')
