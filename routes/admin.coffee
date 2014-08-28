models = require('../models')
Contest = models.Contest

module.exports = router = require('express').Router()

# Check for admin middleware
router.use (req, res, next) ->
  if req.user.is_admin()
    next()
  else
    res.redirect('/')

router.get('/', (req,res) -> res.redirect('/admin/contests'))

router.get '/contests', (req, res) ->
  Contest
    .fetchAll()
    .then (contests) ->
      res.render('admin/contests', {contests: contests.models})

router.post '/contests', (req, res) ->
  new_contest = req.body.contest
  Contest
    .forge(new_contest)
    .save()
    .then (saved_contest) ->
      res.redirect("contests/#{saved_contest.get('id')}")

router.get '/contests/:id', (req, res) ->
  Contest
    .where({id: req.params.id})
    .fetch()
    .then (contest) ->
      res.render('admin/contest', {contest: contest})
