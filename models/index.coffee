config       = require('../config')
pg           = require('knex')(config.db)
bookshelf    = require('bookshelf')(pg)

models = {}

myBookshelf = {}
myBookshelf.Model = bookshelf.Model.extend
  hasMany: (Target, foreignKey) ->
    bookshelf.Model.prototype.hasMany(models[Target], foreignKey)
  belongsTo: (Target, foreignKey) ->
    bookshelf.Model.prototype.belongsTo(models[Target], foreignKey)

models.User     = require('./user')(myBookshelf)
models.Contest  = require('./contest')(myBookshelf)
models.Category = require('./category')(myBookshelf)
models.Entry    = require('./entry')(myBookshelf)
models.Vote     = require('./vote')(myBookshelf)

module.exports = models
