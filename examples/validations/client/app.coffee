Template.A.inheritsHooksFrom("sb_basic")
Template.B.inheritsHooksFrom("sb_basic")

Template.demo.helpers
  data1: ->
    a = Acollection.findOne()
    if a
      new A a
  data: -> new A
    a1: 'hello world'
    a2: 15
    a3: [new B
      b1: 0.0
    ]





