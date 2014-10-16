#!/usr/bin/env node
// tinytest-in-app
// MIT License ben@latenightsketches.com
// .startTest.js

// Run tinytest-in-app and report results to command line
// node .startTest.js [any extra arguments to pass to meteor startup]

var spawn = require('child_process').spawn;
var workingDir = process.env.TEST_APP_WORKING_DIR || './';
var args = process.argv.slice(2);

var meteor; // Will contain meteor process

runMeteor(); // Get started

function runMeteor(){
  console.log('Starting Meteor...');
  meteor = spawn('meteor', args, {cwd: workingDir});
  meteor.stdout.pipe(process.stdout);
  meteor.stderr.pipe(process.stderr);
  meteor.on('close', function (code) {
    console.log('Meteor exited with code ' + code);
    process.exit(code);
  });

  meteor.stdout.on('data', function startTesting(data) {
    var data = data.toString();
    var match = data.match(/ App running at: .+/);
    if(match) {
      var url = match[0].substr(17);
      console.log('Starting Tinytest...');
      meteor.stdout.removeListener('data', startTesting);
      runTestSuite(url);
    } 
  });
};

function runTestSuite(url) {
  var phantomjs = spawn('phantomjs', ['./.phantomRunner.js', url]);
  phantomjs.stdout.pipe(process.stdout);
  phantomjs.stderr.pipe(process.stderr);

  phantomjs.on('close', function(code) {
    meteor.kill('SIGQUIT');
    process.exit(code);
  });
};
