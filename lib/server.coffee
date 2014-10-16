# tinytest-in-app
# MIT License ben@latenightsketches.com
# lib/server.coffee
# Executes Tinytest on server and in PhantomJS client by Meteor method

Future = Npm.require 'fibers/future'
phantomExec = undefined

Meteor.methods
  runTinytest: (options) ->
    options = options || {}
    if not phantomExec
      phantomExec = phantomLaunch
        debug: true
    fut = new Future()
    # Run tests here, on the server
    _runTests options, (error, result) ->
      throw error if error
      _.each result, (test, key) ->
        result['SERVER ' + key] = test
        delete result[key]

      # Run tests in a PhantomJS client
      options.phantomUrl = options.url
      resultClient = phantomExec _runTests, options
      throw resultClient.error if resultClient.error
      _.each resultClient.result, (test, key) ->
        result['CLIENT ' + key] = test

      fut.return(result)
    return fut.wait()
