auth = require('../auth')
express = require('express')
Contest = require('./contest')

app = module.exports = express()
app.use(express.bodyParser())
app.set('views', "#{__dirname}/views")
app.set('view engine', 'jade')

check_admin = [auth.ensureAuthenticated, auth.ensureAdmin]

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
app.get '/contests/:contest_id/categories/:category_id/entries/:entry_id/vote', [auth.ensureAuthenticated], (req, res) ->
  Contest.findById req.params.contest_id, (err, contest) ->
    category = contest.categories.id(req.params.category_id)

    if category.voted_on_by(req.user)
      res.send 418
    else
      entry = category.entries.id(req.params.entry_id)

      if entry?
        entry.votes++
        category.voted.push(req.user.email)

        contest.save (err) ->
          res.redirect("/contests/#{contest.id}")
      else
        res.send 404

app.get '/admin', (req, res) ->
  res.redirect('/admin/contests')

app.get '/admin/contests', check_admin, (req, res) ->
  Contest.find {}, (err, contests) ->
    res.render 'admin_index',
      contests: contests
      user: req.user

app.post '/admin/contests', check_admin, (req, res) ->
  body = req.body
  contest = new Contest(body)
  contest.save (err) ->
    res.redirect("/admin/contests/#{contest.id}")

app.get '/admin/contests/:id', check_admin, (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    res.render 'admin_show',
      contest: contest
      user: req.user

# Admin can add Category to Contest
app.post '/admin/contests/:contest_id/categories', check_admin, (req, res) ->
  Contest.findById req.params.contest_id, (err, contest) ->
    contest.categories.push req.body
    contest.save (err) ->
      res.redirect("/admin/contests/#{contest.id}")


# Admin can add Entry to Category
app.post '/admin/contests/:contest_id/categories/:category_id/entries', check_admin, (req, res) ->
  Contest.findById req.params.contest_id, (err, contest) ->
    category = contest.categories.id(req.params.category_id)
    category.entries.push req.body
    contest.save (err) ->
      res.redirect("/admin/contests/#{contest.id}")
