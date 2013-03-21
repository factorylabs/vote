auth = require('../auth')
express = require('express')
Contest = require('./contest')

app = module.exports = express()
app.use(express.bodyParser())
app.set('views', "#{__dirname}/views")
app.set('view engine', 'jade')

app.get '/', (req, res) -> res.redirect('/contests')

app.get '/login', (req, res) -> res.render('login', user: req.user)

app.get '/contests', (req, res) ->
  Contest.find {open: true}, (err, contests) ->
    if contests.length is 1
      res.redirect("/contests/#{contests[0].id}")
    res.render 'index',
      contests: contests
      user: req.user

app.get '/contests/:id', auth.ensureAuthenticated, (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    res.render 'show',
      contest: contest
      user: req.user

app.get '/contests/:id/leaderboard', (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    res.render 'leaderboard'
      contest: contest
      user: req.user
      sort_desc: (prop) ->
        return (a,b) ->
          if( a[prop] < b[prop])
            return 1
          else if( a[prop] > b[prop] )
            return -1
          return 0

# User vote
app.post '/vote', auth.ensureAuthenticated, (req, res) ->
  req.user.submit_votes req.body.votes, (err) ->
    res.send(200)
