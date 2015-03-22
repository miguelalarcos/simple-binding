Package.describe({
    name: 'miguelalarcos:simple-binding',
    version: '0.2.6',
    summary: 'Simple two way bindings for Meteor',
    git: 'https://github.com/miguelalarcos/simple-binding.git',
    documentation: 'README.md'
});

Package.onUse(function(api) {
    api.versionsFrom('1.0.4.1');
    api.use('coffeescript');
    api.use('tracker');
    api.use('templating');
    api.use('underscore');
    api.use('aldeed:template-extension@3.4.3');
    api.addFiles('simple-binding.html', 'client');
    api.addFiles('simple-binding.css', 'client');
    api.addFiles('simple-binding.coffee', 'client');
    api.export('BaseReactive', 'client');
});

Package.onTest(function(api) {
    api.use('tinytest');
    api.use('tracker');
    api.use('coffeescript');
    api.use('templating');
    api.use('underscore');
    api.use('practicalmeteor:munit', 'client');
    api.use('aldeed:template-extension@3.4.3');
    api.use('miguelalarcos:simple-binding');
    api.addFiles('simple-binding-tests.html', 'client');
    api.addFiles('simple-binding-tests.coffee', 'client');
});
