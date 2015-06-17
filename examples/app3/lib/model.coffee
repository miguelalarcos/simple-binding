@collectionA = new Mongo.Collection('collectionA')

@CSchema = new sb.Schema
  c:
    type: sb.Integer
    validation: (x) -> x > 5

@BSchema = new sb.Schema
  b:
    type: String

@ASchema = new sb.Schema
  a:
    type: String
  b:
    type: BSchema
  c:
    type: [CSchema]