config = require('./config')
express = require('express')

app = express()
app.use(require('method-override')('_method'))
app.use(require('body-parser')())
app.use(require('connect-assets')(helperContext: app.locals))
app.use(require('multer')(dest: './tmp/'))
app.use(express.static("#{__dirname}/public"))
app.set('view engine', 'jade')

if config.env is 'development'
  # A simple log for dev mode
  app.use (req, res, next) ->
    console.log(req.method, req.url)
    next()

app.get('/', (req, res) -> res.redirect('/contests'))
app.use(require('./lib/auth'))
app.use('/contests', require('./routes/contests'))
app.use('/admin', require('./routes/admin'))

app.listen config.port, ->
  console.log "Running on port #{config.port}."
