express = require('express')

app = express()
app.set('views', "#{__dirname}/lib/views")
app.set('view engine', 'jade')
app.use(express.static("#{__dirname}/public"))
app.use(require('connect-assets')())
app.use(require('./lib/auth').Router)
app.use(require('./lib/contest').Router)
app.use(require('./lib/admin').Router)

theport = process.env.PORT or 8080
app.listen theport, ->
  console.log "Running on port #{theport}."
