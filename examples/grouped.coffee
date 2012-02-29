{saq} = require '../saq'

task = (i, j) -> (next) ->
  seconds = 1000 * Math.random()
  execute = (-> console.log "Computation #{i} #{j}"; next();)
  setTimeout execute, seconds


grouped = saq (queue) -> (groups, tasks, cb) ->
  queue.async groups, (next) ->
    for i in [0...groups]
      saq (queue) ->
        for j in [0...tasks]
          queue.async task i, j
        queue.sync next
  queue.sync cb


groups = parseInt process.argv[2]
tasks = parseInt process.argv[3]
grouped groups, tasks, ->
  console.log 'Done!'
