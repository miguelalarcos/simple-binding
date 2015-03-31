Template.A.inheritsHooksFrom("sb_basic")
Template.B.inheritsHooksFrom("sb_basic")

Session.set 'flag', true

Template.demo.helpers
  data: ->
    if Session.get 'flag'
      new A
        a1: 'hello world'
        a2: 15
        a3: [new B
               b1: 0.0
        ]






