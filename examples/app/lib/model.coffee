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
    sex:
      type: String
    flag:
      type: Boolean
    toggle:
      type: Boolean
  fullName: (sep) -> @first + sep + @last
  notcan: -> not @first or not @last
  show: -> @flag and '==> ' + @first
  cansee: -> @first != ''
  picado: -> @toggle = not @toggle

