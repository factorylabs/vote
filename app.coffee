express = require('express')

app = express()
app.set('view engine', 'jade')
app.use(express.static("#{__dirname}/public"))
app.use(require('connect-assets')(helperContext: app.locals))

app.use(require('./lib/auth').Router)
app.use(require('./lib/contest').Router)
app.use(require('./lib/admin').Router)

app.configure 'development', ->
  # A simple log for dev mode
  app.use (req, res, next) ->
    console.log(req.method, req.url)
    next()

theport = process.env.PORT or 8080
app.listen theport, ->
  console.log "Running on port #{theport}."
