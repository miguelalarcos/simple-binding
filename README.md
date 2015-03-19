simple-binding
==============
Simple two way bindings for Meteor.

Explanation
-----------
Given this model:

```coffee
class A extends BaseReactive
  @schema:
    first:
      type: String
    last:
      type: String
    lista:
      type: [String]
    sex:
      type: String
    flag:
      type: Boolean
    toggle:
      type: Boolean
  fullName: (sep) -> @first + sep + @last
  notcan: -> not @first or not @last
  show: -> @flag and '==> ' + @first
  cansee: -> @first != ''
  picado: -> @toggle = not @toggle
```

and this initialization (using ```aldeed:template-extension```):

```coffee
Template.hello2.hooks
  created: ->
    this.model = new A
      first: 'miguel'
      last: 'angel'
      lista: []
      sex: 'female'
```

You can have a template like this:

```html
<template name="hello2">
    <input type="text" sb bind="first">
    <input type="text" sb bind="first">
    {{text 'first'}}
    <br>
    {{text 'fullName' '-'}}
    <br>
    <input type="checkbox" sb value="miguel" check="lista">
    <input type="checkbox" sb value="miguel" check="lista">
    <br>
    <button sb disabled_="notcan" hover='flag' click="picado">click</button>
    {{text 'show'}}
    <div sb visible="cansee">hello world</div>
    <input sb type="radio" name="sex" value="male" radio="sex">Male
    <br>
    <input sb type="radio" name="sex" value="female" radio="sex">Female
    <br>
    <input sb type="radio" name="sex2" value="male" radio="sex">Male
    <br>
    <input sb type="radio" name="sex2" value="female" radio="sex">Female
    <div sb fade="toggle">game over!</div>
</template>
```

The explanation is:
* *sb*, to mark the element as a *simple bind* element.
* *bind* binds the input element with the model field specified.
* *text* is a helper you use to display the field specified (or function that returns a string).
* *check* binds the checkbox to the field specified.
* *disabled_* binds with a function that returns a boolean.
* *click* binds the click action to the given function.
* *radio* binds the radio element with the field specified.
* *fade* binds with a boolean.

Instead of extend from *BaseReactive* you can extend from [*soop.Base*](https://github.com/miguelalarcos/soop), to have the persistence to Mongo.

Roadmap:
* more elements like select
* soop: get the value given a full path => simple-binding then can binds with nested objects.
