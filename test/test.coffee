assert = require('assert')
Contest = require('../lib/contest/contest')
User = require('../lib/user').Model

describe 'Users', ->
  describe 'new', ->
    it 'doesn\'t allow non FDL emails', ->
      foreign_user = new User
        name: 'Intruder'
        email: 'baddie@creeper.com'

      foreign_user.validate (err) ->
        assert.equal(err.errors.email.type, 'Not a FDL email!')

  describe 'admins', ->
    normal_user = new User
      name: 'Joe Blow'
      email: 'joe.blow@factorylabs.com'
    admin_user = new User
      name: 'Boss Man'
      email: 'boss.man@facotrylabs.com'
      admin: true

    it 'should verify admin status', ->
      assert.equal(normal_user.is_admin(), false)
      assert.equal(admin_user.is_admin(), true)

describe 'Contest', ->
  describe 'voting', ->
    user = new User
      name: 'Joe Blow'
      email: 'joe.blow@factorylabs.com'
    contest = new Contest
      name: 'contest 1'
      open: true
    category =
      name: 'category 1'
      entries: []
    entry = name: 'entry 1'

    category.entries.push(entry)
    contest.categories.push(category)

    it 'should let users vote', (done) ->
      user.vote contest.categories[0].entries[0], (err) ->
        assert.equal(category.voted_on_by(user), true)
        done()

    it 'should not allow users to vote twice on a category', (done) ->
      user.vote contest.categories[0].entries[0], (err) ->
        assert.equal(err.message, 'User already voted on category.')
        done()

    it 'should allow users to vote on many entries at once', ->
      category_2 =
        name: 'category 2'
        entries: [
          {name: 'entry 2.1'}
          {name: 'entry 2.2'}
        ]

      contest.categories.push(category_2)

      assert.equal(contest.categories.length, 2)

      votes = []
      for entry in category_2.entries
        votes.push
          contest: contest._id
          category: category_2._id
          entry: entry._id

      user.submit_votes votes, (err) ->
        assert.equal(err, 'yup')
