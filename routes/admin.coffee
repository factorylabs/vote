fs = require('fs')
s3 = require('../lib/s3')
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
      res.redirect("/admin/contests/#{saved_contest.get('id')}")

# Show a contest
router.get '/contests/:contest_id', (req, res) ->
  Contest
    .where({id: req.params.contest_id})
    .fetch({withRelated: ['categories.entries.votes']})
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

# Delete an category
router.delete '/contests/:contest_id/categories/:category_id', (req, res) ->
  Category
    .where({id: req.params.category_id})
    .destroy()
    .then ->
      res.redirect("/admin/contests/#{req.params.contest_id}")

# Create an entry
router.post '/contests/:contest_id/categories/:category_id/entries', (req, res) ->
  attachment = req.files.attachment
  new_entry = req.body.entry
  new_entry.category_id = req.params.category_id
  new_entry.contest_id = req.params.contest_id

  send_response = ->
    Entry
      .forge(new_entry)
      .save()
      .then (saved_entry) ->
        res.redirect("/admin/contests/#{req.params.contest_id}")

  if attachment
    fs.readFile attachment.path, (err, buffer) ->
      filename = attachment.name.replace('.'+attachment.extension,'')+attachment.originalname
      s3req = s3.put "/entries/#{filename}",
        'Content-Length': buffer.length
        'Content-Type': attachment.mimetype
        'x-amz-acl': 'public-read'

      s3req.on 'response', (s3res) ->
        if s3res.statusCode is 200
          new_entry.attachment = s3req.url
          send_response()
        else
          console.log('S3 ERROR!', s3res)
          res.redirect("/admin/contests/#{req.params.contest_id}", {error: s3res})

      s3req.end(buffer) # execute upload
  else
    send_response()

# Delete an entry
router.delete '/contests/:contest_id/entries/:entry_id', (req, res) ->
  Entry
    .where({id: req.params.entry_id})
    .destroy()
    .then ->
      res.redirect("/admin/contests/#{req.params.contest_id}")

# Open a contest
router.post '/contests/:contest_id/open', (req, res) ->
  Contest
    .where({id: req.params.contest_id})
    .fetch()
    .then (contest) ->
      contest.set('open', true)
      contest.save()
      .then (contest) ->
        res.redirect("/admin/contests/#{req.params.contest_id}")

# Close a contest
router.post '/contests/:contest_id/close', (req, res) ->
  Contest
    .where({id: req.params.contest_id})
    .fetch()
    .then (contest) ->
      contest.set('open', false)
      contest.save()
      .then (contest) ->
        res.redirect("/admin/contests/#{req.params.contest_id}")
