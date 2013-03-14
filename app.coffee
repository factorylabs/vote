express = require('express')
config  = require('./settings.json')

app = express()
app.set('views', "#{__dirname}/lib/views")
app.set('view engine', 'jade')
app.use(express.static("#{__dirname}/public"))
app.use(require('connect-assets')())
app.use(require('./lib/auth').Router)
app.use(require('./lib/contest').Router)

app.listen 8080, ->
  console.log 'Running on port 8080.'
