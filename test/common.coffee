process.env.NODE_ENV = process.env.NODE_ENV || 'test'
process.env.APP_ENV = process.env.APP_ENV || 'development'

chai = require('chai')
chai.config.includeStack
global.chai = chai
global.expect = chai.expect
require("../source/app")

realProcessExit = process.exit
process.exit = (code) ->
	setTimeout realProcessExit.bind(process, code), 1000
