{saq} = require '../saq'


active_tasks = 0


task = (i, cb) ->
  active_tasks += 1
  console.log "Active: #{active_tasks}. Starting task #{i}"
  seconds = 2000 * Math.random()
  execute = ->
    console.log "Active: #{active_tasks}. Stopping tasks #{i}"
    active_tasks -= 1
    cb i * i
  setTimeout execute, seconds


windowed = saq (queue) -> (tasks, window, cb) ->
  window = Math.min(window, tasks)
  count = 0
  squares = []

  schedule = (next) ->
    task count, (i) ->
      squares.push i
      schedule next if count < tasks
      next()
    count += 1

  queue.async tasks, (next) ->
    schedule next for i in [0...window]

  queue.sync ->
    sum = 0
    sum += square for square in squares
    cb sum


tasks = parseInt process.argv[2]
window = parseInt process.argv[3]
windowed tasks, window, (sum) ->
  console.log sum
