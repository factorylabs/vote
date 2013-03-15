mongoose = require('../mongoose')
category = require('./category')

contestSchema = new mongoose.Schema
  name: String
  open: {type: Boolean, default: false}
  categories: [category.Schema]

Contest = module.exports = mongoose.model('Contest', contestSchema)
