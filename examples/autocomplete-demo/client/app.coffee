#Template.autocomplete.inheritsHooksFrom("sb_basic")

class A extends sb.Model
  @schema:
    a:
      type: String
      validation: (x) -> surnamesCollection.findOne({surname: x})

Template.xbody.helpers
  myModel: -> new A
    a: ''

Meteor.subscribe 'Surnames'