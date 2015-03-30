Template.A.inheritsHooksFrom("sb_basic")
Template.B.inheritsHooksFrom("sb_basic")

Template.demo.helpers
  data: -> new A
    a1: 'hello world'
    a2: 15
    a3: new B
      b1: 10.5


class B extends sb.ReactiveModel
  @schema:
    b1:
      type: sb.Float
      validation: (x) -> x > 1.0
  validation: ->
    @b1 > 10.0

class A extends sb.ReactiveModel
  @schema:
    a1:
      type: String
      validation: (x) -> /^hello /.test(x)
    a2:
      type: sb.Integer
      validation: (x) -> 10 < x < 20
    a3:
      type: B
  validation: ->
    @a1=='hello world' and @a2==15 and @a3.b1 > 0
  isNotValid: -> not @isValid()

