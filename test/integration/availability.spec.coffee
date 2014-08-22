request = require 'request'

describe 'availability of home page', ->

	describe 'load home page', ->
		resp = null
		bodyReturned = null

		before (done) ->
			request.get 'http://localhost:5000/', (err, _resp, body) ->
				resp = _resp
				bodyReturned = body
				done err
		it 'should return status code 200', ->
			expect(resp.statusCode).to.be.eql 200

		it 'should return body', ->
			expect(resp.body).to.be.ok
