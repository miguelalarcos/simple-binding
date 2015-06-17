Template.A.inheritsHooksFrom("sb_basic")
Template.B.inheritsHooksFrom("sb_basic")
Template.C.inheritsHooksFrom("sb_basic")

class C extends sb.Model
  @schema: CSchema


class B extends sb.Model
  @schema: BSchema

class A extends sb.Model
  @collection: collectionA
  @schema: ASchema
  click: ->
    @b = new B(b: 'insert coin')
    @c.set 0, new C(c: 7)
    @c.push new C(c: 8)
  texto: -> 'hola ' + @a
  reset: -> Session.set 'A_id', null

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