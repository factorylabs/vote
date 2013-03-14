mongoose = require('../mongoose')
category = require('./category')

contestSchema = new mongoose.Schema
  name: String
  categories: [category.Schema]

Contest = module.exports = mongoose.model('Contest', contestSchema)
