process.env.NODE_ENV = process.env.NODE_ENV || 'test'
process.env.APP_ENV = process.env.APP_ENV || 'development'
port = process.env.PORT = process.env.PORT || 5001

global.baseUrl = "http://localhost:#{port}"

chai = require('chai')
chai.use(require('chai-pretty-expect'));
chai.config.includeStack
global.expect = chai.expect
require("../source/app")

