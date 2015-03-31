Acollection.allow
  insert: (userId, doc) ->
    console.log new A(doc).validate()
    new A(doc).isValid()
  update: (userId, doc, fields, modifier) ->
    doc = modifier['$set']
    new A(doc).isValid()

