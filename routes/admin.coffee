User = require('../models/user')

module.exports = router = require('express').Router()

# Check for admin middleware
router.use (req, res, next) ->
  if req.user.is_admin()
    next()
  else
    res.redirect('/')

router.get '/', (req, res) ->
  res.render('admin')
