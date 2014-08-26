env = process.env.NODE_ENV or 'development'

config   = require('./config')

db_config =
  client: 'pg'
  connection: config.pg_connection_string
  debug: true

pg = require('knex')(db_config)
bookshelf = require('bookshelf')(pg)
User = require('./models/user')(bookshelf)

express = require('express')

app = express()
app.set('view engine', 'jade')
app.use(express.static("#{__dirname}/public"))
app.use(require('connect-assets')(helperContext: app.locals))

app.get('/', (req, res) -> res.redirect('/vote'))
app.use(require('./lib/auth')(User))
app.use('/vote', require('./routes/vote'))
app.use('/admin', require('./routes/admin'))

if env is 'development'
  # A simple log for dev mode
  app.use (req, res, next) ->
    console.log(req.method, req.url)
    next()

app.listen config.port, ->
  console.log "Running on port #{config.port}."
