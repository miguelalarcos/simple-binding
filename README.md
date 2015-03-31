[![Build Status](https://travis-ci.org/miguelalarcos/simple-binding.svg)](https://travis-ci.org/miguelalarcos/simple-binding)

simple-binding
==============
Simple two way bindings for Meteor.

Explanation
-----------
You can see a demo with explanation [here](http://simple-binding.meteor.com). See also the example that comes with the package.
Please note that till not reach the v1.0.0 the API may change.

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
* *sb-events* binds to several jQuery events.
* *sb-custom-bool* binds to a bool custom widget. See the examples to know how to do it.
* *sb-datetime* binds to a Date.

In the case of an attribute that is an array, it will be converted to a reactive array, and you can use *push*, *pop*, *shift*, *unshift*, *splice* and a method *set* that is ```set=(pos, value)->```. You can use yourself the *reactiveArray*, this way:

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

You can use nested expressions like:

```html
<input type="text" sb sb-disabled="alias.0.notCan" sb-bind="alias.0.alias">
<div sb sb-text="age.value">
```

You can set a model to null:

```coffee
... = new A
  a1: new B()
  a2: null # instead of new C(), for example
```

Be careful, because if you have a computation that uses the model you set to null and you use the related ui component, you will have errors.
So is better to hide the component in those cases:

```html
<input type="checkbox" sb sb-bool="age.cow.houses.0.tv" sb-visible="age.cow.houses.0">
```

The package uses ```aldeed:template-extension```, so you have to do, to initialize every template:

```coffee
Template.B.inheritsHooksFrom("sb_basic")
```

The model is an instance of *Model*:

```coffee
class A extends sb.Model
  @schema:
    first:
      type: String
    last:
      type: String
    lista:
      type: [Number]
    age:
      type: B
  can: -> @first and @last
  listaToString: -> @lista.toString()
  isOld: -> @age.value > 18
  age17: -> @age = new B
    value: 17
    cow: new Cow
      speak: 'muu!!!'
      houses: [new House(tv:false)]
  push: -> @age.cow.houses.push(new House(tv: true))
```

Validations
-----------
You can have validations as in this example:

```coffee
@Acollection = new Mongo.Collection 'A'

class B extends sb.Model
  @schema:
    b1:
      type: sb.Float
      validation: (x) -> x > 1.0
  validation: ->
    @b1 > 10.0

class A extends sb.Model
  @collection: Acollection
  @schema:
    a1:
      type: String
      validation: (x) -> /^hello/.test(x)
    a2:
      type: sb.Integer
      validation: (x) -> 10 < x < 20
    a3:
      type: B
  validation: ->
    @a1=='hello world' and @a2==15 and @a3.b1 > 0
```

```html
<button sb sb-disabled="isNotValid" sb-click="save">save</button>
```

As you can see there's a validation rule for every field and a general validation that has visibility of all fields.
The *Model* has three util methods of validation: *validate*, *isValid*, *isNotValid*. *validate* returns an object where keys are the path of every attribute, and value is true or false depending if it passes the validation.
Also, it has a method *save* that will insert or update the object into the given collection. You have to do server side validation. This is an example on how to do it:
```coffee
Acollection.allow
  insert: (userId, doc) ->
    new A(doc).isValid()
  update: (userId, doc, fields, modifier) ->
    doc = modifier['$set']
    new A(doc).isValid()
```

Issues
------
Issue: be careful when using {{#if ...}} because the single elements inside probably will not have the chance to bind, not the templates inside that will bind in created event (not tested).
(The elements have the chance to bind because the template where they are is rendered).

Notes
-----
*schema* is a reserved word. Example of use:
```coffee
error_a2: -> if not @schema['a2'].validation(@a2) then 'error de integer 10<x<20' else ''
```

TODO:
-----
* fully integrate with [soop](https://github.com/miguelalarcos/soop).
* more tests.
* examples with more sense :)
* dirty attribute so the update only updates the modified attributes. (may be will not be implemented)
* implement *exclude* server side and test both sides.


