Acollection.allow
  insert: (userId, doc) ->
    new A(doc).isValid()
  update: (userId, doc, fields, modifier) ->
    doc = modifier['$set']
    new A(doc).isValid()

