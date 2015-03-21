[![Build Status](https://travis-ci.org/miguelalarcos/simple-binding.svg)](https://travis-ci.org/miguelalarcos/simple-binding)

simple-binding
==============
Simple two way bindings for Meteor.

Explanation
-----------
You can see a demo [here](http://simple-binding.meteor.com).

Given this model:

```coffee
class C extends BaseReactive
  @schema:
    email:
      type: String

class B extends BaseReactive
  @schema:
    alias:
      type: String
    toggle:
      type: Boolean
    emails:
      type: [C]
  aliasFunc: -> 'the alias is ' + @alias
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
Template.hello2.inheritsHelpersFrom("sb_basic")

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
        emails: [new C(email:'m@m.es'), new C(email: 'm2@m.es')]
      ]
```

You can have a template like this:

```html
<template name="hello2">
    first name:
    <input type="text" sb sb-bind="first">
    <input type="text" sb sb-bind="first">
    <textarea sb sb-bind="first"></textarea>
    ---
    <span sb sb-text="first"></span>
    <br>
    <div sb sb-text="fullName" sb-class="classesFunc"></div>
    <br>
    Miguel at the cinema?<input type="checkbox" sb value="miguel" sb-check="lista">
    Miguel at the cinema?<input type="checkbox" sb value="miguel" sb-check="lista">
    <br>
    Boolean: <input type="checkbox" sb sb-bool="flag">
    Boolean: <input type="checkbox" sb sb-bool="flag">
    <br>
    <button sb sb-disabled="notCan" sb-hover='flag' sb-click="clicked">hover me</button>
    <span sb sb-text="show"></span>
    <div sb sb-visible="canSee">this text will disappear if first is empty</div>
    <input sb type="radio" name="sex" value="male" sb-radio="sex">Male
    <br>
    <input sb type="radio" name="sex" value="female" sb-radio="sex">Female
    <br>
    <input sb type="radio" name="sex2" value="male" sb-radio="sex">Male
    <br>
    <input sb type="radio" name="sex2" value="female" sb-radio="sex">Female
    <div sb sb-fade="alias.0.toggleFunc">game over!</div>
    <br>
    alias: type 'miguel' to disable:<input type="text" sb sb-disabled="alias.0.notCan" sb-bind="alias.0.alias">
    <br>
    Who is at the cinema?
    <select sb sb-select="lista" multiple="multiple">
        <option>miguel</option>
        <option>veronica</option>
        <option>bernardo</option>
    </select>
    <select sb sb-select="lista" multiple="multiple">
        <option>miguel</option>
        <option>veronica</option>
        <option>bernardo</option>
    </select>
    <br>
    Select first name:
    <select sb sb-select="first">
        <option>veronica</option>
        <option>bernardo</option>
        <option>miguel</option>
    </select>
    <select sb sb-select="first">
        <option>veronica</option>
        <option>bernardo</option>
        <option>miguel</option>
    </select>
    <br>
    <button sb sb-click="pop">pop</button>
    <div sb sb-text="sum"></div>
    <br>
    {{#with model}}
        {{#each list 'alias'}}
            <span sb sb-text="{{path 'aliasFunc'}}"></span>
            <input type="text" sb sb-bind="{{path 'alias'}}">
            {{#each list 'emails'}}
                <span sb sb-text="{{path 'email'}}"></span>
                <input type="text" sb sb-bind="{{path 'email'}}">
            {{/each}}
        {{/each}}
    {{/with}}
    <br>
    {{#with subModel 'alias.0.emails.0'}}
        <span sb sb-text="{{path 'email'}}"></span>
        <input type="text" sb sb-bind="{{path 'email'}}">
    {{/with}}
</template>
```

Where:

* *sb*, to mark the element as a *simple bind* element.
* *sb-bind* binds the input element with the model field specified.
* *sb-text* is a helper you use to display the field specified (or function that returns a string).
* *sb-check* binds the checkbox to a list (checked if its value is in the list).
  *sb-bool* binds the checkbox to a boolean field.
* *sb-disabled* binds with a function that returns a boolean.
* *sb-click* binds the click action to the given function.
* *sb-radio* binds the radio element with the field specified.
* *sb-fade* binds with a boolean.
* *sb-select* to binds a select element with a list or an attribute depending if is multiple or not.
* *sb-class* to binds the classes of the element to a function.

In the case of an attribute that is an array, you can use *push*, *pop*, *shift*, *unshift*, *splice* and a method *set* that is ```set=(pos, value)->```. Those set the dependency of the attribute to changed().

In the template you can see:

```html
{{#with model}}
    {{#each list 'alias'}}
        <div>{{this.alias}}</div>
        <input type="text" sb sb-bind="{{path 'alias'}}">
...
```

where you have to set the context of the model and iterate 'alias' thanks to *list*, that sets an attribute *_path* in each element. Later you use *path* to get the current path plus the attribute you want to bind to.

or

```html
    {{#with subModel 'alias.0.emails.0'}}
        <span sb sb-text="{{path 'email'}}"></span>
        <input type="text" sb sb-bind="{{path 'email'}}">
    {{/with}}
```

where subModel sets the context to that doc.

Note: Instead of extend from *BaseReactive* you can extend from [*soop.Base*](https://github.com/miguelalarcos/soop), to have the persistence to Mongo.

TODO:
* fully integrate with ```soop```.
