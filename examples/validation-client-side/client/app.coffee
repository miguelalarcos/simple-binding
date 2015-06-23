#Template.A.inheritsHooksFrom("sb_basic")

class A extends sb.Model
  @schema:
    a:
      type: sb.Integer
      validation: (x) -> x > 5
  error_a: -> if not @validation('a') then 'error not > 5' else ''

model = new A(a:8)

Template.xbody.helpers
  myModel: -> model