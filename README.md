[![Build Status](https://travis-ci.org/miguelalarcos/simple-binding.svg)](https://travis-ci.org/miguelalarcos/simple-binding)

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
    numbers:
      type: [Number]
  classesFunc: -> if @flag then 'myClass' else ''
  fullName: -> @first + ' ' + @last + ', alias: ' + @alias[0].alias
  notCan: -> not @first or not @last
  show: -> (@flag and '==> ' + @first) or ''
  canSee: -> @first != ''
  sum: ->
    ret = 0
    for x in @numbers
      ret += x
    ret
  pop: ->
    @numbers.pop()
  clicked: ->
    @alias[0].toggle = not @alias[0].toggle
    @lista = ['miguel']
    @first = 'miguel'
    @sex = 'male'
    @numbers.push Math.floor((Math.random() * 10) + 1)
```

and this initialization (using ```aldeed:template-extension```):

```coffee
Template.hello2.inheritsHooksFrom("sb_basic")

Template.hello2.hooks
  created: ->
    this.model = new A
      first: 'miguel'
      last: 'alarcos'
      lista: ['miguel']
      numbers: []
      sex: 'male'
      alias: [new B
        alias: 'mola'
      ]
```

You can have a template like this:

```html
<template name="hello2">
    first name:
    <input type="text" sb bind="first">
    <input type="text" sb bind="first">
    <textarea sb bind="first"></textarea>
    ---
    <span sb text="first"></span>
    <br>
    <div sb text="fullName" classes="classesFunc"></div>
    <br>
    Miguel at the cinema?<input type="checkbox" sb value="miguel" check="lista">
    Miguel at the cinema?<input type="checkbox" sb value="miguel" check="lista">
    <br>
    Boolean: <input type="checkbox" sb bool="flag">
    Boolean: <input type="checkbox" sb bool="flag">
    <br>
    <button sb disabled_="notCan" hover='flag' click="clicked">hover me</button>
    <span sb text="show"></span>
    <div sb visible="canSee">this text will disappear if first is empty</div>
    <input sb type="radio" name="sex" value="male" radio="sex">Male
    <br>
    <input sb type="radio" name="sex" value="female" radio="sex">Female
    <br>
    <input sb type="radio" name="sex2" value="male" radio="sex">Male
    <br>
    <input sb type="radio" name="sex2" value="female" radio="sex">Female
    <div sb fade="alias.0.toggleFunc">game over!</div>
    <br>
    alias: type 'miguel' to disable:<input type="text" sb disabled_="alias.0.notCan" bind="alias.0.alias">
    <br>
    Who is at the cinema?
    <select sb select_="lista" multiple="multiple">
        <option>miguel</option>
        <option>veronica</option>
        <option>bernardo</option>
    </select>
    <select sb select_="lista" multiple="multiple">
        <option>miguel</option>
        <option>veronica</option>
        <option>bernardo</option>
    </select>
    <br>
    Select first name:
    <select sb select_="first">
        <option>veronica</option>
        <option>bernardo</option>
        <option>miguel</option>
    </select>
    <select sb select_="first">
        <option>veronica</option>
        <option>bernardo</option>
        <option>miguel</option>
    </select>
    <br>
    <button sb click="pop">pop</button>
    <div sb text="sum"></div>
</template>
```

Where:

* *sb*, to mark the element as a *simple bind* element.
* *bind* binds the input element with the model field specified.
* *text* is a helper you use to display the field specified (or function that returns a string).
* *check* binds the checkbox to a list (checked if its value is in the list).
  *bool* binds the checkbox to a boolean field.
* *disabled_* binds with a function that returns a boolean.
* *click* binds the click action to the given function.
* *radio* binds the radio element with the field specified.
* *fade* binds with a boolean.
* *select_* to binds a select element with a list or an attribute depending if is multiple or not.

Instead of extend from *BaseReactive* you can extend from [*soop.Base*](https://github.com/miguelalarcos/soop), to have the persistence to Mongo.


