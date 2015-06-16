Template.A.inheritsHooksFrom("sb_basic")
Template.B.inheritsHooksFrom("sb_basic")

class B extends sb.Model
  @schema:
    b:
      type: String

class A extends sb.Model
  @schema:
    a:
      type: String
    b:
      type: B
  click: -> @b = new B(b: 'insert coin')

Template.xbody.helpers
  myModel: -> new A
    a:'hola mundo'
    b: new B
      b: 'game over!'