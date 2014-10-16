// tinytest-in-app
// MIT License ben@latenightsketches.com
// .phantomRunner.js

// runTinyTest() with pass-through console output and exit

var page = require('webpage').create();
var system = require('system');
var url = system.args[1];
var passed = false;
var tinytestActive = false;

page.onConsoleMessage = function (message) {
  console.log(message);
  if(tinytestActive){
    switch(message) {
      case 'All tests passed!':
        passed = true;
        break;
      case 'TINYTEST COMPLETE':
        phantom.exit(passed ? 0 : 1);
        break;
    };
  };
};

console.log("Running Meteor tests in PhantomJS...");
page.open(url, function(status){
  if(status !== 'success'){
    console.log('Cannot load app at', url);
    phantom.exit(1);
  };
  tinytestActive = true;
  page.evaluate(function(){
    runTinytest();
  });
});
