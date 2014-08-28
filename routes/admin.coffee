models = require('../models')
Contest = models.Contest
Category = models.Category
Entry = models.Entry

module.exports = router = require('express').Router()

# Check for admin middleware
router.use (req, res, next) ->
  if req.user.is_admin()
    next()
  else
    res.redirect('/')

# Show all contests
router.get('/', (req,res) -> res.redirect('/admin/contests'))
router.get '/contests', (req, res) ->
  Contest
    .fetchAll()
    .then (contests) ->
      res.render('admin/contests', {contests: contests.toJSON()})

# Create a contest
router.post '/contests', (req, res) ->
  new_contest = req.body.contest
  Contest
    .forge(new_contest)
    .save()
    .then (saved_contest) ->
      res.redirect("contests/#{saved_contest.get('id')}")

# Show a contest
router.get '/contests/:contest_id', (req, res) ->
  Contest
    .where({id: req.params.contest_id})
    .fetch({withRelated: ['categories', 'categories.entries']})
    .then (contest) ->
      res.render('admin/contest', {contest: contest.toJSON()})

# Create a category
router.post '/contests/:contest_id/categories', (req, res) ->
  new_category = req.body.category
  new_category.contest_id = req.params.contest_id
  Category
    .forge(new_category)
    .save()
    .then (saved_category) ->
      res.redirect("/admin/contests/#{req.params.contest_id}")

# Create an entry
router.post '/contests/:contest_id/categories/:category_id/entries', (req, res) ->
  new_entry = req.body.entry
  new_entry.category_id = req.params.category_id
  # new_entry.contest_id = req.params.contest_id
  Entry
    .forge(new_entry)
    .save()
    .then (saved_entry) ->
      res.redirect("/admin/contests/#{req.params.contest_id}")
