chai = require 'chai'
sinon = require 'sinon'

# publish globals that all specs can use
global.expect = chai.expect
global.sinon = sinon

beforeEach ->
  @sinon = sinon.sandbox.create()

afterEach ->
  @sinon.restore()
