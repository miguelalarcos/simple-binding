@collectionA = new Mongo.Collection('collectionA')

class @C extends sb.Model
  @schema:
    c:
      type: sb.Integer
      validation: (x) -> x > 5


class @B extends sb.Model
  @schema:
    b:
      type: String

class @A extends sb.Model
  @collection: collectionA
  @schema:
    a:
      type: String
    b:
      type: B
    c:
      type: [C]
  click: ->
    @b = new B(b: 'insert coin')
    @c.set 0, new C(c: 7)
    @c.push new C(c: 8)
  texto: -> 'hola ' + @a
  reset: -> Session.set 'A_id', null