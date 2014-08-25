crypto         = require('crypto')
express        = require('express')
cookieParser   = require('cookie-parser')
methodOverride = require('method-override')
session        = require('express-session')
connect_pg     = require('connect-pg-simple')(session)
User           = require('../models/user')
config         = require('../config')

module.exports = router = express.Router()

# configure Express
router.use(methodOverride())
router.use(cookieParser(config.secret))
router.use session
  secret: config.secret
  store: new connect_pg(conString: config.pg_connection_string)

# Ensure users are authenticated
router.use (req, res, next) ->
  if req.path is '/logout' or
    req.path is '/login' or
    req.path is '/session/remote'
      next()
  else if req.session.authenticated
    user_id = req.session.user_id
    if user_id
      User.findById user_id, (err, user) ->
        if err or !user
          return res.redirect('/logout', {error: 'Missing user'})
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
  signature = "
    #{auth['firstname']}\
    #{auth['lastname']}\
    #{auth['email']+auth['timestamp']}\
    #{config.onelogin_token}
  "
  shasum.update(signature)
  signature = shasum.digest('hex')

  if signature is auth['signature']
    # trusted
    full_name = "#{auth['firstname']} #{auth['lastname']}"
    User.findOne {email: auth['email']}, (err, user) ->
      if user
        # Existing user, update info
        user.name = full_name
        user.email = auth['email']

        user.populate_core_user (err, success) ->
          return res.render('logout', {error: err}) unless success
          user.save (err) ->
            return res.render('logout', {error: err})(err) if err
            req.session.authenticated = true
            req.session.user_id = user._id
            res.redirect('/')
      else
        new_user = new User
          name: full_name
          email: auth['email']

        new_user.populate_core_user (err, success) ->
          new_user.save (err) ->
            return res.render('logout', {error: err.message}) if err
            res.redirect('/')

router.get '/logout', (req, res) ->
  req.session.destroy ->
    res.render('logout')
