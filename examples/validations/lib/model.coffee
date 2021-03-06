@Acollection = new Mongo.Collection 'A'

class @B extends sb.Model
  @exclude = []
  @schema:
    b1:
      type: sb.Float
      validation: (x) -> x > 1.0
  validation: ->
    @b1 > 10.0
  error_b1: -> if not @schema['b1'].validation(@b1) then 'error not > 1.0' else ''
  error_g: -> if not @validation() then 'error not > 10.0' else ''

class @A extends sb.Model
  @exclude = []
  @collection: Acollection
  @schema:
    a1:
      type: String
      validation: (x) -> /^hello/.test(x)
    a2:
      type: sb.Integer
      validation: (x, self) -> if /^H/.test(self.a1) then 10 < x < 20 else x>0
    a3:
      type: [B]
  validation: ->
    @a1=='hello world' and @a2==15 and @a3[0].b1 > 0
  error_a1: -> if not @schema['a1'].validation(@a1) then 'not match /^hello/' else ''
  error_a2: -> if not @schema['a2'].validation(@a2, @) then 'error de integer 10<x<20' else ''
  error_g: -> if not @validation() then "error not @a1=='hello world' and @a2==15 and @a3[0].b1 > 0" else ''
  push: -> @a3.push(new B(b1: 0.0))
  reset_model: ->
    Session.set 'flag', false
    Session.set 'flag', true
