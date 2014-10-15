# tinytest-in-app
# MIT License ben@latenightsketches.com
# lib/runner.coffee 
# Run tests on this location (client/server/phantomjs)

# @option {string} pathPrefix - only run specified tests
# @option {string} phantomUrl - set when running in PhantomJS context,
#                               url to browse to
# @param {func} callback(error, result) - data provided when complete
@runTests = (options, callback) ->
  options = options || {}

  if options.phantomUrl
    # Running in PhantomJS context
    webpage = require 'webpage'
    page = webpage.create()
    page.onCallback = (data) ->
      callback undefined, data
    page.open options.phantomUrl, (status) ->
      if status == 'fail'
        callback 'load-failure'
      else
        options.phantomUrl = undefined
        runInPage = (options) ->
          runTests options, (error, result)->
            window.callPhantom
              error: error
              result: result
        page.evaluate runInPage, options
    return

  status = {}
  onReport = (report) ->
    key = report.groupPath.join(' - ') + ' - ' + report.test
    if status[key] == undefined
      status[key] =
        events: []
        passed: true
    report.events.forEach (event) ->
      switch event.type
        when 'ok'
          status[key].events.push 'ok'
        when 'fail'
          status[key].passed = false
          status[key].events.push event.details
        when 'finish'
          status[key].finished = true
          status[key].time = event.timeMs
  onComplete = ->
    callback undefined, status
  Tinytest._runTests onReport, onComplete, options.pathPrefix

