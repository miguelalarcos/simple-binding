simple-binding
==============
Simple two way bindings for Meteor.

Explanation
-----------
You can see a demo [here](http://simple-binding.meteor.com).

Given this model:

```coffee
class B extends BaseReactive
  @schema:
    alias:
      type: String
    toggle:
      type: Boolean
  notCan: -> @alias == 'miguel'
  toggleFunc: -> @toggle

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
    alias:
      type: [B]
    flag:
      type: Boolean
  fullName: -> @first + ' ' + @last + ', ' + @alias[0].alias
  notCan: -> not @first or not @last
  show: -> (@flag and '==> ' + @first) or ''
  canSee: -> @first != ''
  picado: ->
    @alias[0].toggle = not @alias[0].toggle
    @lista = ['miguel']
    @first = 'miguel'
    @sex = 'male'
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
      alias: [new B
        alias: 'mola'
      ]
```

You can have a template like this:

```html
<template name="hello2">
    <input type="text" sb bind="first">
    <input type="text" sb bind="first">
    <textarea sb bind="first"></textarea>
    ---
    <span sb text="first"></span>
    <br>
    <div sb text="fullName"></div>
    <br>
    Miguel at the cinema?<input type="checkbox" sb value="miguel" check="lista">
    Miguel at the cinema?<input type="checkbox" sb value="miguel" check="lista">
    <br>
    <button sb disabled_="notCan" hover='flag' click="picado">click</button>
    <span sb text="show"></span>
    <div sb visible="canSee">hello world</div>
    <input sb type="radio" name="sex" value="male" radio="sex">Male
    <br>
    <input sb type="radio" name="sex" value="female" radio="sex">Female
    <br>
    <input sb type="radio" name="sex2" value="male" radio="sex">Male
    <br>
    <input sb type="radio" name="sex2" value="female" radio="sex">Female
    <div sb fade="alias.0.toggleFunc">game over!</div>
    <br>
    type 'miguel' to disable:<input type="text" sb disabled_="alias.0.notCan" bind="alias.0.alias">
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

