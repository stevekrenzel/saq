{saq} = require '../saq'


asyncHi = saq (queue) -> (name, cb) ->
  queue.sync ->
    console.log 'Hello'

  queue.async (next) ->
    console.log name
    setTimeout next, 500

  queue.sync cb


name = process.argv.splice(2).join(' ')
asyncHi name, ->
  console.log 'Done!'
