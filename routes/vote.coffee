# User = require('../models/user')

module.exports = router = require('express').Router()

router.get '/', (req, res) ->
  req.user.load(['votes'])
    .then (user) ->
      req.user = res.locals.user = user
      res.render('vote')
