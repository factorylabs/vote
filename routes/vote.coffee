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
        res.render('vote', {contests: contests.toJSON()})
      else
        res.redirect("/contests/#{contests.first().get('id')}")
