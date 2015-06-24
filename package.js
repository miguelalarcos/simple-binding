Package.describe({
    name: 'miguelalarcos:simple-binding',
    version: '0.7.1',
    summary: 'Simple two way bindings for Meteor, with nested models and validation.',
    git: 'https://github.com/miguelalarcos/simple-binding.git',
    documentation: 'README.md'
});

Package.onUse(function(api) {
    api.versionsFrom('1.0.5');
    api.use('coffeescript');
    api.use('tracker');
    api.use('jquery');
    api.use('templating');
    api.use('underscore');
    api.use('reactive-var');
    api.use('momentjs:moment@2.9.0');
    //api.use('aldeed:template-extension@3.4.3');
    api.addFiles('main-simple-binding.coffee', ['client', 'server']);
    api.addFiles('sb-datetime.css', 'client');
    api.addFiles('sb-datetime.html', 'client');
    api.addFiles('sb-datetime.coffee', 'client');
    api.addFiles('sb-autocomplete.css', 'client');
    api.addFiles('sb-autocomplete.html', 'client');
    api.addFiles('sb-autocomplete.coffee', 'client');
    api.addFiles('simple-binding.html', 'client');
    api.addFiles('simple-binding-client.coffee', 'client');
    api.addFiles('simple-binding-server.coffee', 'server');
    api.export('sb', ['client', 'server']);
});

Package.onTest(function(api) {
    api.use('tinytest');
    api.use('tracker');
    api.use('coffeescript');
    api.use('jquery');
    api.use('templating');
    api.use('underscore');
    api.use('practicalmeteor:munit', ['client', 'server']);
    api.use('miguelalarcos:simple-binding');
    api.addFiles('simple-binding-tests.html', 'client');
    api.addFiles('simple-binding-tests.coffee', 'client');
    api.addFiles('simple-binding-tests-validations.coffee', 'server');
});
