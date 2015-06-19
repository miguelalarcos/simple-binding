Template.autocomplete.inheritsHooksFrom("sb_basic")

class A extends sb.Model
  @schema:
    a:
      type: String

Template.xbody.helpers
  myModel: -> new A
    a: ''