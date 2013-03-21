mongoose = module.exports = require('mongoose')
uristring = process.env.MONGOLAB_URI or 'mongodb://localhost/instagram-voting'

mongoose.connect uristring, (err, res) ->
  if err
    console.log('ERROR connecting to: ' + uristring + '. ' + err)
