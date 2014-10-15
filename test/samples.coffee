# tinytest-in-app
# MIT License ben@latenightsketches.com
# test/samples.coffee
# Example tests to match browser output with console output

Tinytest.add 'nada', (test) ->
  # A test without a test

Tinytest.add 'simple', (test) ->
  test.equal true, true

Tinytest.add 'simple failure', (test) ->
  test.equal true, false

if Meteor.isServer
  Tinytest.add 'server only', (test) ->
    test.equal true, true

if Meteor.isClient
  Tinytest.add 'client only', (test) ->
    test.equal true, true

Tinytest.add 'multiple - checks with failure', (test) ->
  test.equal true, false
  test.equal true, true

Tinytest.addAsync 'multiple - checks success + async', (test, done) ->
  test.equal true, true
  Meteor.setTimeout ( ->
    test.equal true, true
    done()
  ), 1000
