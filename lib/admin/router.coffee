auth = require('../auth')
express = require('express')
Contest = require('../contest/contest')

app = module.exports = express()
app.use(express.bodyParser())
app.set('views', "#{__dirname}/views")
app.set('view engine', 'jade')

check_admin = [auth.ensureAuthenticated, auth.ensureAdmin]

app.get '/admin', (req, res) ->
  res.redirect('/admin/contests')

app.get '/admin/contests', check_admin, (req, res) ->
  Contest.find {}, (err, contests) ->
    res.render 'index',
      contests: contests
      user: req.user

# Admin can create a Contest
app.post '/admin/contests', check_admin, (req, res) ->
  body = req.body
  contest = new Contest(body)
  contest.save (err) ->
    res.redirect("/admin/contests/#{contest.id}")

app.get '/admin/contests/:id', check_admin, (req, res) ->
  Contest.findById req.params.id, (err, contest) ->
    res.render 'show',
      contest: contest
      user: req.user

app.post '/admin/contests/:id', check_admin, (req, res) ->
  contest_update = req.body
  if req.body.open? && req.body.open == 'false'
    contest_update.open = false

  if req.body.show_results? && req.body.show_results == 'false'
    contest_update.show_results = false

  Contest.findByIdAndUpdate req.params.id, contest_update, (err, contest) ->
    res.json contest

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
