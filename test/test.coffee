assert = require('assert')
User = require('../lib/user').Model

describe 'Array', ->
  describe '#indexOf()', ->
    it 'should return -1 when the value is not present', ->
      assert.equal(-1, [1,2,3].indexOf(5))
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
