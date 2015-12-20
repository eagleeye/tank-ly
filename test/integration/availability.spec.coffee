request = require 'request'

describe 'availability of static pages', ->

	['/', '/m/1', '/bot/1', '/hostroom/1', '/qr/1'].forEach (page) ->
		describe "load page '#{page}'", ->
			resp = null
			bodyReturned = null

			before (done) ->
				request.get "#{baseUrl}#{page}", (err, _resp, body) ->
					resp = _resp
					bodyReturned = body
					done err
			it 'should return status code 200', ->
				expect(resp.statusCode, resp.body).to.be.eql 200

			it 'should return body', ->
				expect(resp.body).to.be.ok
