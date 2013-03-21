assert = require('assert')
Contest = require('../lib/contest/contest')
User = require('../lib/user').Model

describe 'Contests', ->
  describe 'voting', ->
    user = new User
      name: 'Joe Blow'
      email: 'joe.blow@factorylabs.com'

    contest = new Contest
      name: 'contest 1'
      open: true
      categories: [
        {name: 'category 1', entries: [{name: 'entry 1'}]}
        {name: 'category 2', entries: [{name: 'entry 2.1'}, {name: 'entry 2.2'}]}
      ]

    after (done) ->
      contest.remove ->
        done()

    it 'should let users vote', (done) ->
      user.vote contest.categories[0].entries[0], (err) ->
        assert.equal(contest.categories[0].voted_on_by(user), true)
        assert.equal(contest.categories[0].entries[0].votes, 1)
        done()

    it 'should not allow users to vote twice on a category', (done) ->
      user.vote contest.categories[0].entries[0], (err) ->
        assert.equal(err.message, 'User already voted on category.')
        done()

    it 'should allow users to vote on many entries at once', (done) ->
      votes = []
      for entry in contest.categories[1].entries
        votes.push
          contest: contest._id
          category: contest.categories[1]._id
          entry: entry._id

      user.submit_votes votes, (err, entries) ->
        assert.equal(err.length, 0)
        assert.equal(entries[0].votes, 1)
        assert.equal(entries[1].votes, 1)
        done()
