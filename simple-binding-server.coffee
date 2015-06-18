class Model

sb.Model = Model

denyIfNotValid = (model) ->
  collection = model.collection
  schema = model.schema
  collection.deny
    insert: (userId, doc) ->
      not sb.validate(doc, schema)
    update: (userId, doc, fields, modifier) ->
      doc = modifier['$set']
      not sb.validate(doc, schema)

allowIfValid = (model) ->
  collection = model.collection
  schema = model.schema
  collection.allow
    insert: (userId, doc) ->
      sb.validate(doc, schema)
    update: (userId, doc, fields, modifier) ->
      doc = modifier['$set']
      sb.validate(doc, schema)

sb.denyIfNotValid = denyIfNotValid
sb.allowIfValid = allowIfValid