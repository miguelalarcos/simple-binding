class B extends sb.Model
  @schema:
    b:
      type: sb.Integer

class A extends sb.Model
  @schema:
    a:
      type: String
    b1:
      type: B
    b2:
      type: [B]
  click: ->
    @b2.set(0,new B(b:0))
    @b2.push(new B(b:1))

Template.xbody.helpers
  myModel: -> new A
    a:'hola mundo'
    b1: new B(b:1)
    b2: [new B(b:7)]