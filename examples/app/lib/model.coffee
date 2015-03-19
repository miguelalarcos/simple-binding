aCollection = new Mongo.Collection "A"

class @B extends soop.InLine
  @schema:
    alias:
      type: String
  hello: -> 'hello ' + @alias

class @A extends soop.Base
  @collection: aCollection
  @schema:
    first:
      type: String
    last:
      type: String
    alias:
      type: B
    lista:
      type: [String]
    flag:
      type: Boolean
  fullName: (sep) -> @first + sep + @last
  notcan: -> not @first or not @last
  show: -> @flag and '==> ' + @first

