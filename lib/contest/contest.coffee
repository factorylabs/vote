mongoose = require('../mongoose')
category = require('./category')

contestSchema = new mongoose.Schema
  name: String
  open: {type: Boolean, default: false}
  show_results: {type: Boolean, default: true}
  categories: [category.Schema]

Contest = module.exports = mongoose.model('Contest', contestSchema)
