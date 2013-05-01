mongoose = require('../mongoose')

exports.Schema = new mongoose.Schema
  name: String
  slug: String
  image_url: String
  votes: {type: Number, default: 0}

