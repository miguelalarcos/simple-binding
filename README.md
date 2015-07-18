[![Build Status](https://travis-ci.org/miguelalarcos/simple-binding.svg)](https://travis-ci.org/miguelalarcos/simple-binding)

simple-binding
==============
Simple two way bindings for Meteor, with nested models and validation.

Explanation
-----------
You can see a demo with explanation [here](http://simple-binding.meteor.com). See also the example that comes with the package.
Please note that till not reach the v1.0.0 the API may change.

API
---

* *sb*, to mark the element as a *simple bind* element.
* *sb-bind* binds the input element with the model field specified.
* *sb-text* is a helper you use to display the field specified (or function that returns a string).
* *sb-html* is a helper you use to display html of the field specified (or function).
* *sb-check* binds the checkbox to a list (checked if its value is in the list).
  *sb-bool* binds the checkbox to a boolean field.
* *sb-disabled* binds with a function that returns a boolean.
* *sb-click* binds the click action to the given function.
* *sb-radio* binds the radio element with the field specified.
* *sb-fade* binds the boolean result of a function or boolean.
  *sb-fade-speed* (milliseconds)
  *sb-fade-easing*
* *sb-select* to binds a select element with a list or an attribute depending if is multiple or not. The package uses *select2* internally.
* *sb-class* to bind the classes of the element to the result of a function.
* *sb-focus* binds to a boolean.
* *sb-hover* binds to a boolean.
* *sb-visible* binds to a var or function.
* *sb-events* binds to several jQuery events.
* *sb-custom-widget* binds to a custom widget. See example *app2* where there's a custom boolean widget.
* *sb-datetime* binds to a Date.
* *sb-autocomplete* binds to an autocomplete widget.

The *sb-autocomplete* is not explained in the example above, so I explain it here: (see the autocomplete-demo)
the example of use is:

```html
{{> sbAutocomplete sb-autocomplete='a' call='data' fieldRef='surname' renderKey='surname' id='demoId'}}
```

Note that you have to give an *id*.

```coffee
Meteor.methods
  data: (query) -> surnamesCollection.find({surname: {$regex: '^.*'+query+'.*$'}}).fetch()
```

The validation should be a function like this (more on validations later):

```coffee
validation: (x) ->
  if Meteor.isServer
    surnamesCollection.findOne({surname: x})
  else
    sb.isValidAutocomplete('demoId')
```

If you use the *renderFunction* instead of *renderKey*:

```coffee
@surnameFunc = (x, query) -> Blaze.toHTMLWithData(Template.surname, x)
```

```html
<template name="surname">
    <td>{{this.name}} <b>{{this.surname}}</b></td>
</template>
```

---
In the case of an attribute that is an array, it will be converted to a ReactiveArray (reactiveArray is deprecated), and you can use *push*, *pop*, *shift*, *unshift*, *splice*, *remove*, *extract* (returns the array) and a method *set* that is ```set=(pos, value)->```. You can use yourself the *ReactiveArray*, this way:

```coffee
names = new ReactiveArray(['miguel', 'veronica', 'bernardo'])

Template.hello2.helpers
  options: ->
    names.depend()
    names
```

This is an example on how to call a template:

```html
<body>
    {{> xbody }}
</body>

<template name="xbody">
    {{> sbT template='A' model=myModel}}
</template>

<template name="A">
    <input type="text" sb sb-bind="a">
    <div sb sb-text="a"></div>
    {{#each this.model.emails}}
        {{> sbT template='C' model=this}}
    {{/each}}
    {{> sbT template='D' model=this.model.cow}}
</template>
```

You can use nested expressions like:

```html
<input type="text" sb sb-disabled="alias.0.notCan" sb-bind="alias.0.alias">
<div sb sb-text="age.value">
```

You can set a model without values:

```coffee
... = new A
  a1: new B({})
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
      type: BSchema
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

Types
-----
You can use the next types: String, Date, Boolean, sb.Html, sb.Integer, sb.Float and other model types.

Medium editor
-------------
It's not included out of the box in the package, but is very simple to code it. Here's an example:

```html
<template name="htmlMediumEditor">
    <div sb {{this}} class="editable"></div>
</template>
```

```css
.editable {
    height: 10em;
}
```

```coffee
Template.htmlMediumEditor.onRendered ->
  el = this.$('.editable')
  new MediumEditor(el, {placeholder: false})
  
class @Post extends sb.Model
  @collection: posts
  @schema:
    ...
    text:
      type: sb.Html
    ...
```

```html
<template name="edit-post">
        ...
        Texto:
        {{> htmlMediumEditor sb-bind="text"}}
        ...
```        

Validations
-----------
You can have validations as in this example:

```coffee
# in lib folder, for example, so client and server can see the next definitions
@Acollection = new Mongo.Collection 'A'

class @B extends sb.Model
  @schema:
    b1:
      type: sb.Float
      optional: true
      validation: (x) -> x > 1.0
  error_b1: -> if not @validation('b1') then 'error not > 1.0' else ''

class @A extends sb.Model
  @collection: Acollection
  @schema:
    a1:
      type: String
      validation: (x) -> /^hello/.test(x)
    a2:
      type: sb.Integer
      validation: (x, self) -> if /^H/.test(self.a1) then 10 < x < 20 else x>0
    a3:
      type: [BSchema]
  error_a1: -> if not @validation('a1') then 'not match /^hello/' else ''
  error_a2: -> if not @validation('a2') then 'error de integer 10<x<20' else ''
```

As you can see there's a validation rule for every field, that is passed the attribute that is going to be validated and a second argument with the object.
The *Model* has two util methods of validation: *isValid*, *isNotValid*.
Also, it has a method *save* that will insert or update the object into the given collection, and a method *remove*.

You can use the methods *canEdit* and *canRemove* that will return true or false depending if you can edit or remove the object.

Forms
-----

You can have a *form* like this (see the validation example):

```html
<template name="B">
    <input type="text" sb sb-bind="b1">
    <div sb sb-text="error_b1"></div>
</template>

<template name="A">
    <input type="text" sb sb-bind="a1">
    <div sb sb-text="error_a1"></div>
    <input type="text" sb sb-bind="a2">
    <div sb sb-text="error_a2"></div>
    {{#each this.model.a3}}
        {{> sbT template='B' model= this }}
    {{/each}}
    <button sb sb-disabled="isNotValid" sb-click="save">save</button>
</template>
```

You have to do server side validation. This is an example on how to do it:
```coffee
sb.allowIfValid(model)
#sb.denyIfNotValid(model)
```

But I highly recommend to use *ongoworks:security*. The deny function would be something like:

```coffee     
Security.defineMethod "ifSbValidate",
  fetch: [],
  transform: null,
  deny: (type, arg, userId, doc, fields, modifier) ->
    if type == 'update'
      doc = modifier['$set']
    if sb.validate(doc, arg.schema)
      false
    else
      true      
```

removeFromContainer
-------------------

Each model object has a method called *removeFromContainer* that removes this model instance from the array that contains it, if any. Example:

```coffee
class B extends sb.Model
  @schema:
    b:
      type: sb.Integer
  remove: -> @removeFromContainer()
```

datetime widget
---------------
Example of use:
```html
{{> sbDateTime sb-datetime="dummyDate" format="DD-MM-YYYY HH:mm" id="unico" time=true}}
```

Issues
------
Issue: be careful when using {{#if ...}} because the single elements inside probably will not have the chance to bind, not the templates inside that will bind in created event (not tested).
(The elements have the chance to bind because the template where they are is rendered).

Notes
-----
*schema* is a reserved word. Example of use: (deprecated)
```coffee
error_a2: -> if not @schema['a2'].validation(@a2) then 'error de integer 10<x<20' else ''
```

TODO:
-----
* more tests. (important)
* examples with more sense :)
* dirty attribute so the update only updates the modified attributes. (maybe will not be implemented)
* implement *exclude* server side and test both sides.
* implement arrays for primitives (now you can use objects with the keyword 'value') fully functional.