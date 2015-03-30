Template.A.inheritsHooksFrom("sb_basic")
Template.B.inheritsHooksFrom("sb_basic")

Template.demo.helpers
  data: -> new A
    a1: 'hello world'
    a2: 15
    a3: new B
      b1: 10.5





