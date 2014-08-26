crypto         = require('crypto')
express        = require('express')
cookieParser   = require('cookie-parser')
methodOverride = require('method-override')
session        = require('express-session')
connect_pg     = require('connect-pg-simple')(session)
config         = require('../config')

module.exports = (User) ->

  router = express.Router()

  # configure Express
  router.use(methodOverride())
  router.use(cookieParser(config.secret))
  router.use session
    secret: config.secret
    store: new connect_pg(conString: config.pg_connection_string)
    resave: true
    saveUninitialized: true

  # Ensure users are authenticated
  router.use (req, res, next) ->
    if req.path is '/logout' or
      req.path is '/login' or
      req.path is '/session/remote'
        next()
    else if req.session.authenticated
      user_id = req.session.user_id
      if user_id
        User
          .where({id: user_id})
          .fetch()
          .then (user) ->
            req.user = res.locals.user = user
            next()
      else
        res.redirect('/logout', {error: 'Corrupt session'})
    else
      res.redirect('/login')

  router.get '/login', (req, res) ->
    res.redirect(config.onelogin_url)

  router.get '/session/remote', (req, res) ->
    auth = req.query
    shasum = crypto.createHash('sha1')
    signature = auth['firstname']+auth['lastname']+auth['email']+auth['timestamp']+config.onelogin_token

    shasum.update(signature)
    signature = shasum.digest('hex')

    if signature is auth['signature'] # trusted
      full_name = "#{auth['firstname']} #{auth['lastname']}"
      User
        .where({email: auth['email']})
        .fetch({require: true})
        .then (user) ->
          # Existing user, update info.
          user.set
            name: full_name
            email: auth['email']
          user
            .save()
            .then (saved_user) ->
              req.session.authenticated = true
              req.session.user_id = saved_user.id
              res.redirect('/')
        .catch User.NotFoundError, (err) ->
          # User doesn't exist, make one!
          User
            .forge
              name: full_name
              email: auth['email']
            .save()
            .then (saved_user) ->
              req.session.authenticated = true
              req.session.user_id = saved_user.id
              res.redirect('/')
        .catch (err) ->
          console.log(err)
          res.status(500)

  router.get '/logout', (req, res) ->
    req.session.destroy ->
      res.render('logout')

  return router
