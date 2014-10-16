# tinytest-in-app
# MIT License ben@latenightsketches.com
# lib/client.coffee
# Front end for Tinytest

@runTinytest = (options) ->
  options = options || {}
  options.url = document.location.origin
  Meteor.call 'runTinytest', options,
    (error, result) ->
      throw error if error
      reportResults [result]

reportResults = (results) ->
  countTotal = 0
  countFail = 0
  results.forEach (result) ->
    _.each result, (test, key) ->
      countTotal++
      countFail++ if not test.passed
      console.log \
        (if test.passed then 'PASS' else 'FAIL'), \
        key, \
        '(' + test.time + 'ms)', \
        (if test.passed and test.events then \
            'OK ' + test.events.length + ' time' + \
            (if test.events.length != 1 then 's' else '') \
         else test.events)
  if countTotal == 0
    console.log 'No tests found!'
  else if countFail == 0
    console.log 'All tests passed!'
  else
    console.log countFail + ' of ' + countTotal + ' tests failed!'
  console.log 'TINYTEST COMPLETE'
