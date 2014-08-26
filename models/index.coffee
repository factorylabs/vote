config       = require('../config')
pg           = require('knex')(config.db)
bookshelf    = require('bookshelf')(pg)
exports.User = require('./user')(bookshelf)
