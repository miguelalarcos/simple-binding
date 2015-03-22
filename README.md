[![Build Status](https://travis-ci.org/miguelalarcos/simple-binding.svg)](https://travis-ci.org/miguelalarcos/simple-binding)

simple-binding
==============
Simple two way bindings for Meteor.

Explanation
-----------
You can see a demo with explanation [here](http://simple-binding.meteor.com). See also the example that comes with the package.

API
---

* *sb*, to mark the element as a *simple bind* element.
* *sb-bind* binds the input element with the model field specified.
* *sb-text* is a helper you use to display the field specified (or function that returns a string).
* *sb-check* binds the checkbox to a list (checked if its value is in the list).
  *sb-bool* binds the checkbox to a boolean field.
* *sb-disabled* binds with a function that returns a boolean.
* *sb-click* binds the click action to the given function.
* *sb-radio* binds the radio element with the field specified.
* *sb-fade* binds the boolean result of a function.
* *sb-select* to binds a select element with a list or an attribute depending if is multiple or not.
* *sb-class* to bind the classes of the element to the result of a function.
* *sb-focus* binds to a boolean.
* *sb-hover* binds to a boolean.

In the case of an attribute that is an array, you can use *push*, *pop*, *shift*, *unshift*, *splice* and a method *set* that is ```set=(pos, value)->```. Those set the dependency of the attribute to changed().

In the template of the example you can see, when iterating:

```html
{{#with model}}
    {{#each list 'alias'}}
        <input type="text" sb sb-bind="{{path 'alias'}}">
...
```

where you have to set the context of the model and iterate 'alias' thanks to *list*, that sets an attribute *_path* in each element. Later you use *path* to get the current path plus the attribute you want to bind to.

or

```html
    {{#with subModel 'alias.0.emails.0'}}
        <input type="text" sb sb-bind="{{path 'email'}}">
    {{/with}}
```

where subModel sets the context to that doc.

The package uses ```aldeed:template-extension```, so you have to do, to initialize:

```coffee
Template.hello2.inheritsHooksFrom("sb_basic")
Template.hello2.inheritsHelpersFrom("sb_basic")

Template.hello2.hooks
  created: ->
    this.model = new A
      first: 'miguel'
      last: 'alarcos'
      lista: ['miguel']
      numbers: []
      flag: false
      sex: 'male'
      alias: [new B
        alias: 'mola'
        emails: [new C(email:'m@m.es'), new C(email: 'm2@m.es')]
      ]
```

Note: Instead of extend from *BaseReactive* you can extend from [*soop.Base*](https://github.com/miguelalarcos/soop), to have the persistence to Mongo.

TODO:
* fully integrate with ```soop```.
* path is a reserve word you can not use in your models. I will remove this restriction in a future release.
