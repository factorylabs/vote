models = require('../models')
Contest = models.Contest
Category = models.Category
Entry = models.Entry
Vote = models.Vote

module.exports = router = require('express').Router()

router.get '/', (req, res) ->
  Contest
    .where({open: true})
    .fetchAll()
    .then (contests) ->
      if contests.length is 1
        res.redirect("/contests/#{contests.first().get('id')}")
      else
        res.render('contests', {contests: contests.toJSON()})

router.get '/:contest_id', (req, res) ->
  Contest
    .where({id: req.params.contest_id})
    .fetch({withRelated: ['categories.entries', 'votes']})
    .then (contest) ->
      already_voted = contest.already_voted_by(req.user)
      contest = contest.toJSON()
      contest.already_voted = already_voted
      res.render('contest', {contest: contest})

router.post '/:contest_id/vote', (req, res) ->
  entries = req.body.entries
  current_user = req.user
  votes = 0
  for entry in entries
    new_vote =
      contest_id: req.params.contest_id
      entry_id: entry.id
      user_id: current_user.get('id')

    Vote
      .forge(new_vote)
      .save()
      .then ->
        votes++
        if votes is entries.length
          res.redirect("/contests/#{req.params.contest_id}")
