Template.A.inheritsHooksFrom("sb_basic")
Template.A.inheritsHelpersFrom("sb_basic")
Template.B.inheritsHooksFrom("sb_basic")
Template.B.inheritsHelpersFrom("sb_basic")
Template.Cow.inheritsHooksFrom("sb_basic")
Template.Cow.inheritsHelpersFrom("sb_basic")
Template.House.inheritsHooksFrom("sb_basic")
Template.House.inheritsHelpersFrom("sb_basic")

Template.bodyTemplate.helpers
  data: ->
    new A
      first: 'miguel'
      age: new B
        value: 20
        cow: new Cow
          speak: 'muu'
          houses: [new House(tv: true)]

class House extends BaseReactive
  @schema:
    tv:
      type: Boolean


class Cow extends BaseReactive
  @schema:
    speak:
      type: String
    houses:
      type: [House]

class B extends BaseReactive
  @schema:
    value:
      type: Number
    cow:
      type: Cow

class A extends BaseReactive
  @schema:
    first:
      type: String
    age:
      type: B
  isOld: -> @age.value > 18
  age17: -> @age = new B
    value: 17
    cow: new Cow
      speak: 'muu!!!'
      houses: [new House(tv:false)]

Template.Cow.helpers
  echo: (x)-> console.log x