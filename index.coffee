config = require('./config')
express = require('express')

app = express()
app.use(require('body-parser')())
app.use(require('connect-assets')(helperContext: app.locals))
app.use(express.static("#{__dirname}/public"))
app.set('view engine', 'jade')

if config.env is 'development'
  # A simple log for dev mode
  app.use (req, res, next) ->
    console.log(req.method, req.url)
    next()

app.get('/', (req, res) -> res.redirect('/vote'))
app.use(require('./lib/auth'))
app.use('/vote', require('./routes/vote'))
app.use('/admin', require('./routes/admin'))

app.listen config.port, ->
  console.log "Running on port #{config.port}."
