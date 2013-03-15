auth = require('../auth')
express = require('express')
Contest = require('./contest')

app = module.exports = express()
app.use(express.bodyParser())
app.set('views', "#{__dirname}/views")
app.set('view engine', 'jade')

app.get '/', (req, res) ->
  res.redirect('/contests')

app.get '/contests', (req, res) ->
  Contest.find {}, (err, contests) ->
    res.render 'index',
      contests: contests
      user: req.user

app.get '/contests/:id', auth.ensureAuthenticated, (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    res.render 'show',
      contest: contest
      user: req.user

# User vote
app.post '/vote', auth.ensureAuthenticated, (req, res) ->
  Contest.findById req.body.contest, (err, contest) ->
    category = contest.categories.id(req.body.category)

    if category.voted_on_by(req.user)
      res.send(418)
    else
      entry = category.entries.id(req.body.entry)

      if entry?
        entry.votes++

        unless req.user.kiosk
          category.voted.push(req.user.email)

        contest.save (err) ->
          res.send(200)
      else
        res.send(404)
