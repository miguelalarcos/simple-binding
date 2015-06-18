Template.A.inheritsHooksFrom("sb_basic")
Template.B.inheritsHooksFrom("sb_basic")
Template.C.inheritsHooksFrom("sb_basic")

Session.set 'A_id', null

Template.xbody.helpers
  myModel: ->
    if Session.get('A_id') is null
      new A
        a:'mundo'
        b: new B
          b: 'game over!'
        c: [new C(c: 5)]
    else
      new A collectionA.findOne(_id: Session.get('A_id'))
  items: -> collectionA.find({})

Template.xbody.events
  'click .item': (e,t)->
    Session.set 'A_id', $(e.target).attr('_id')