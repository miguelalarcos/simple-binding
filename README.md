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
* *sb-visible* binds to a var or function.

In the case of an attribute that is an array, it will be converted to *ReactiveArray*, and you can use *push*, *pop*, *shift*, *unshift*, *splice* and a method *set* that is ```set=(pos, value)->```. You can use yourself the *ReactiveArray*, this way:

```coffee
names = reactiveArray(['miguel', 'veronica', 'bernardo'])

Template.hello2.helpers
  options: ->
    names.depend()
    names
```

This is an example on how to call a template:

```html
<template name="B">
    {{#withModel}}
        <span sb sb-text="aliasFunc"></span>
        <input type="text" sb sb-bind="alias">
        {{#each emails}}
            {{>C model=this}}
        {{/each}}
        {{>D model=this.cow}}
    {{/withModel}}
</template>
```

* {{#withModel}} It sets the model in the context and rebinds the template with a new model if the model change.
* {{>C model=this}}. You have to pass the model to the template.
* {{>D model=this.subModel}} The same but this is not an array.

You can set a model to null:
```coffee
... = new A
  a1: new B()
  a2: null # instead of new C(), for example
```

The package uses ```aldeed:template-extension```, so you have to do, to initialize every template:

```coffee
Template.B.inheritsHooksFrom("sb_basic")
```

The model is an instance of *BaseReactive*:

```coffee
class Cow extends BaseReactive
  @schema:
    speak:
      type: String
    houses:
      type: [House]
```

Note: Instead of extend from *BaseReactive* you can extend from [*soop.Base*](https://github.com/miguelalarcos/soop), to have the persistence to Mongo.

TODO:
-----
* fully integrate with ```soop```. Not tested.
* more tests.
