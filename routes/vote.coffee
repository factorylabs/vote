# User = require('../models/user')

module.exports = router = require('express').Router()

router.get '/', (req, res) ->
  res.render('vote')
