should = require 'should'

getPriceHistory = require '../lib/getPriceHistory'


describe 'getPriceHistory(...)', ->
  it 'should be done', (done) ->
    getPriceHistory 'B00CGEHNU8', (err, results) ->
      should.not.exist err
      should.exist results
      should.exist results.product
      should.exist results.product.AMAZON
      should.exist results.product.MARKET_NEW
      should.exist results.product.MARKET_USED

      done()
