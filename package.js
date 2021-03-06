// tinytest-in-app
// MIT License ben@latenightsketches.com

Package.describe({
  name: 'numtel:tinytest-in-app',
  summary: 'See https://github.com/numtel/meteor-leaderboard-tinytest',
  version: '0.0.6',
  git: "https://github.com/numtel/tinytest-in-app.git",
  debugOnly: true
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@0.9.3.1');
  api.use('tinytest');
  api.use('coffeescript');
  api.use('underscore');
  api.use('numtel:phantomjs-persistent-server@0.0.8');
  api.addFiles('lib/runner.coffee');
  api.addFiles('lib/server.coffee', 'server');
  api.addFiles('lib/client.coffee', 'client');
  api.export('runTinytest');
});

Package.onTest(function(api) {
  api.use('coffeescript');
  api.use('tinytest');
  api.use('numtel:tinytest-in-app');
  api.addFiles('test/samples.coffee');
});
