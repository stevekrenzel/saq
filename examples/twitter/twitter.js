(function() {
  var parallelSearch, search, serialSearch;

  search = function(keyword, cb) {
    var host, url;
    host = "http://search.twitter.com/";
    url = "" + host + "/search.json?q=" + keyword + "&callback=?";
    return $.getJSON(url, function(json) {
      return cb(json.results);
    });
  };

  parallelSearch = saq(function(queue) {
    return function(keywords, cb) {
      var out;
      out = [];
      queue.async(keywords.length, function(next) {
        return keywords.map(function(k, i) {
          return search(k, function(json) {
            out[i] = json;
            return next();
          });
        });
      });
      return queue.sync(function() {
        return cb(out);
      });
    };
  });

  serialSearch = saq(function(queue) {
    return function(keywords, cb) {
      var out;
      out = [];
      keywords.map(function(k, i) {
        return queue.async(function(next) {
          return search(k, function(json) {
            out[i] = json;
            return next();
          });
        });
      });
      return queue.sync(function() {
        return cb(out);
      });
    };
  });

  $('.search').submit(function() {
    var term, terms;
    terms = (function() {
      var _i, _len, _ref, _results;
      _ref = $('.terms').val().split(',');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        term = _ref[_i];
        _results.push(term.trim());
      }
      return _results;
    })();
    serialSearch(terms, function(results) {
      return results.map(function(tweets) {
        return tweets.map(function(tweet) {
          return $('.results').append("<div>" + tweet.text + "</div>");
        });
      });
    });
    return false;
  });

}).call(this);
