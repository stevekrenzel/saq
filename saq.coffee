after = (times, fn) -> ->
  fn arguments... if --times < 1

isFunction = (obj) ->
  toString.call(obj) == '[object Function]'

saq = (fn) ->
  queue = []
  index = 0

  enqueue = (n, fn) ->
    [n, fn] = [1, n] unless fn?
    queue.splice index++, 0, [n, fn]

  dequeue = ->
    index = 0
    if queue.length > 0
      [n, fn] = queue.shift()
      fn after n, dequeue

  gn = fn
    async: enqueue
    sync: (fn) ->
      enqueue (next) ->
        fn()
        next()

  dequeue() unless isFunction gn

  ->
    gn arguments...
    dequeue()

if @window?
  @saq = saq
else
  exports.saq = saq
