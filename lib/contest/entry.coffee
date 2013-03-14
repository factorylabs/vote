mongoose = require('../mongoose')

exports.Schema = new mongoose.Schema
  name: String
  slug: String
  votes: {type: Number, default: 0}

