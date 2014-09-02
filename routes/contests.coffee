models = require('../models')
Contest = models.Contest
Category = models.Category
Entry = models.Entry

module.exports = router = require('express').Router()

router.get '/', (req, res) ->
  Contest
    .fetchAll({where: open: true})
    .then (contests) ->
      if contests.length is 1
        res.redirect("/contests/#{contests.first().get('id')}")
      else
        res.render('contests', {contests: contests.toJSON()})

router.get '/:contest_id', (req, res) ->
  Contest
    .where({id: req.params.contest_id})
    .fetch({withRelated: ['categories', 'categories.entries']})
    .then (contest) ->
      res.render('contest', {contest: contest.toJSON()})
