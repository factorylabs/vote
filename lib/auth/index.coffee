express        = require('express')
passport       = require('passport')
GoogleStrategy = require('passport-google').Strategy
User           = require('../user').Model

# Passport session setup.
passport.serializeUser (user, done) ->
  done(null, user._id)

passport.deserializeUser (id, done) ->
  User.findById id, (err, user) ->
    done(err, user)

# Use the GoogleStrategy within Passport.
domain = process.env.DOMAIN or 'localhost:8080'
domain = "http://#{domain}/"
google_strategy_options =
  returnURL: "#{domain}auth/google/return"
  realm: domain
passport.use new GoogleStrategy google_strategy_options, (identifier, profile, done) ->
  user_email = profile.emails[0].value

  User.findOne {openId: identifier}, (err, user) ->
    if user
      user.name = profile.displayName
      user.email = user_email
      user.save (err) -> done(err, user)
    else
      new_user = new User
        openId: identifier
        name: profile.displayName
        email: user_email
      new_user.save (err) ->
        done(err, new_user)

app = module.exports.Router = express()

# configure Express
app.use(express.cookieParser())
app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(express.session({secret: 'yellow snow'}))
# Initialize Passport!  Also use passport.session() middleware, to support
# persistent login sessions (recommended).
app.use(passport.initialize())
app.use(passport.session())

# Simple route middleware to ensure user is authenticated.
#   Use this route middleware on any resource that needs to be protected.  If
#   the request is authenticated (typically via a persistent login session),
#   the request will proceed.
ensureAuthenticated = module.exports.ensureAuthenticated = (req, res, next) ->
  return next() if (req.isAuthenticated())
  res.redirect('/')

ensureAdmin = module.exports.ensureAdmin = (req, res, next) ->
  return next() if req.user?.admin
  res.redirect('/')

# GET /auth/google
#   Use passport.authenticate() as route middleware to authenticate the
#   request.  The first step in Google authentication will involve redirecting
#   the user to google.com.  After authenticating, Google will redirect the
#   user back to this application at /auth/google/return
app.get '/auth/google', passport.authenticate('google', { failureRedirect: '/' }), (req, res) ->
  res.redirect('/')

# GET /auth/google/return
#   Use passport.authenticate() as route middleware to authenticate the
#   request.  If authentication fails, the user will be sent home, unauthed
#   Otherwise, the primary route function function will be called,
#   which, in this example, will redirect the user to the home page.
app.get '/auth/google/return', passport.authenticate('google', { failureRedirect: '/' }), (req, res) ->
  res.redirect('/')

app.get '/logout', (req, res) ->
  req.logout()
  res.redirect('/')
