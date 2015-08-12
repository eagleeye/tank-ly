process.env.NODE_ENV = process.env.NODE_ENV || 'test'
process.env.APP_ENV = process.env.APP_ENV || 'development'

chai = require('chai')
chai.use(require('chai-pretty-expect'));
chai.config.includeStack
global.expect = chai.expect
require("../source/app")

