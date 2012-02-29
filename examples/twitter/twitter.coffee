search = (keyword, cb) ->
  host = "http://search.twitter.com/"
  url = "#{host}/search.json?q=#{keyword}&callback=?"
  $.getJSON url, (json) -> cb json.results


parallelSearch = saq (queue) -> (keywords, cb) ->
  out = []
  queue.async keywords.length, (next) ->
    keywords.map (k, i) ->
      search k, (json) -> out[i] = json; next()
  queue.sync -> cb out


serialSearch = saq (queue) -> (keywords, cb) ->
  out = []
  keywords.map (k, i) ->
    queue.async (next) ->
      search k, (json) -> out[i] = json; next()
  queue.sync -> cb out


$('.search').submit ->
  terms = (term.trim() for term in $('.terms').val().split(','))
  serialSearch terms, (results) ->
    results.map (tweets) ->
      tweets.map (tweet) ->
        $('.results').append "<div>#{tweet.text}</div>"
  false
