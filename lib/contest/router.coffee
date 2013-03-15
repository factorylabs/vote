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
  votes = req.body.votes
  contest_id = votes[0].contest # assumes all votes are for same contest

  Contest.findById contest_id, (err, contest) ->
    errors = []
    success = 0

    for vote in votes
      do (vote) ->
        category = contest.categories.id(vote.category)

        if category.voted_on_by(req.user)
          errors.push
            message: 'User has already voted on category.'
            vote: vote

          if success + errors.length == votes.length
            res.json errors: errors
        else
          entry = category.entries.id(vote.entry)

          if entry?
            entry.votes++

            unless req.user.kiosk
              category.voted.push(req.user.email)

            contest.save (err) ->
              success++
              if success == votes.length
                res.send(200)
          else
            errors.push
              message: 'Can\'t find entry'
              vote: vote
            if success + errors.length == votes.length
              res.json errors: errors
