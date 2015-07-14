Package.describe({
    name: 'miguelalarcos:simple-binding',
    version: '0.7.15',
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
    api.use('reactive-dict');
    api.use('momentjs:moment@2.9.0');
    api.use('benmgreene:moment-range@1.0.7');
    api.use('pagebakers:ionicons@2.0.1_1');
    api.use('natestrauser:select2@3.5.1');
    api.use('lookback:dropdowns@1.2.0');
    //api.addFiles('select2.css', 'client');
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
    api.addFiles('simple-binding-tests-bdd.coffee', 'client');
});
