zlib = require 'zlib'
request = require 'request'
cheerio = require 'cheerio'


getPriceHistoryAjaxObject = (url, callback) ->
  request
    url: url
    encoding: null
  ,
    (err, resp, buffer) ->
      return callback err  if err?

      zlib.gunzip buffer, (err, gunzipedBuffer) ->
        return callback err  if err?
        
        try
          callback null, JSON.parse gunzipedBuffer.toString()[1..-3]
        catch err
          callback err


getDateFromKeepaHours = (keepaHours) ->
  offset = 1293840000000 + (new Date().getTimezoneOffset() * 60000)
  
  new Date offset + (keepaHours * 3600000)



module.exports = (asin, options, callback) ->
  return callback new Error 'invalid asin'  if not asin?

  if typeof options is 'function'
    callback = options
    options = {}

  url = "http://dyn.keepa.com/110#{asin}"

  getPriceHistoryAjaxObject url, (err, priceHistory) ->
    return callback err  if err?

    for market in [ 'AMAZON', 'MARKET_NEW', 'MARKET_USED' ]
      priceMap = {}

      for element, index in priceHistory.product[market]
        if index % 2 is 0
          k = getDateFromKeepaHours element
        else
          v = element
          v = element / 100  if element > 0
          priceMap[k] = v

      priceHistory.product[market] = priceMap

    callback null, priceHistory
