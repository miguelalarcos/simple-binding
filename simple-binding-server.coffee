isSubClass = (klass, super_) ->
  klass.prototype instanceof super_

getter_setter = (obj, attr) ->
  get: ->
    obj[attr]
  set: (value) ->
    if value != obj[attr]
      obj[attr] = value

class Model
  @exclude = []
  constructor: (dct)->
    @schema = @constructor.schema
    for attr, value of @constructor.schema
      Object.defineProperty @, attr, getter_setter(@, '_' + attr)
    for k, sch of @schema
      v = dct[k]
      if v is undefined  or v is null
        continue
      if _.isArray(v) and isSubClass(sch.type[0], Model) and not (v[0] instanceof sch.type[0])
        ret = []
        for a in v
          ret.push new sch.type[0](a)
        @[k] = ret
      if isSubClass(sch.type, Model) and not (v instanceof sch.type)
        @[k] = new sch.type(v)
      else
        @[k] = v

  _validate: (ret, path) ->
    for attr, sch of @constructor.schema
      if not sch.optional and @[attr] is undefined
        ret[path + '.' + attr + '.required'] = false
      if @[attr] isnt undefined
        if sch.type == String and not _.isString(@[attr])
          ret[path + '.' + attr + '.type'] = false
        else if (sch.type == sb.Integer or sch.type == sb.Float) and not _.isNumber(@[attr])
          ret[path + '.' + attr + '.type'] = false
        else if sch.type == Boolean and not _.isBoolean(@[attr])
          ret[path + '.' + attr + '.type'] = false
        else if sch.type == Date and not _.isDate(@[attr])
          ret[path + '.' + attr + '.type'] = false
        else if isSubClass(sch.type, sb.Model)
          if not (@[attr] instanceof sb.Model)
            ret[path + '.' + attr + '.type'] = false
          else
            @[attr].validate(ret, path + '.' + attr)
        #
    for attr, sch of @constructor.schema
      if sch.validation and _.isEmpty(ret)
        ret[path + '.' + attr + '.validation'] = sch.validation(@[attr], @)

    if @validation and _.isEmpty(ret)
      ret[path + '.validation'] = @validation()
    ret

  __validate: (ret, path) ->
    for attr, sch of @constructor.schema
      if not (sch.optional and not @[attr])
        if sch.type == String
          ret[path + '.' + attr + '.type'] = _.isString(@[attr])
        else if sch.type == sb.Integer or sch.type == sb.Float
          ret[path + '.' + attr + '.type'] = _.isNumber(@[attr])
        else if sch.type == Boolean
          ret[path + '.' + attr + '.type'] = _.isBoolean(@[attr])
        else if sch.type == Date
          ret[path + '.' + attr + '.type'] = _.isDate(@[attr])
        else if @[attr] instanceof sb.Model
          ret[path + '.' + attr + '.type'] = @[attr] instanceof sb.Model
          @[attr].validate(ret, path + '.' + attr)
          continue
      if sch.validation
        ret[path + '.' + attr + '.validation'] = sch.validation(@[attr], @)
    ret

  validate: (ret, path) ->
    if not ret
      ret = {}
      path = ''
    @_validate(ret, path)
    #if @validation
    #  ret[path + '.validation'] = @validation()
    ret

  isValid: ->
    for k, v of @validate()
      if not v
        return false
    return true

  isNotValid: -> not @isValid()

sb.Model = Model
denyIfNotValid = (klass) ->
  klass.collection.deny
    insert: (userId, doc) ->
      new klass(doc).isNotValid()
    update: (userId, doc, fields, modifier) ->
      doc = modifier['$set']
      new klass(doc).isNotValid()

allowIfValid = (klass) ->
  klass.collection.allow
    insert: (userId, doc) ->
      new klass(doc).isValid()
    update: (userId, doc, fields, modifier) ->
      doc = modifier['$set']
      new klass(doc).isValid()

sb.denyIfNotValid = denyIfNotValid
sb.allowIfValid = allowIfValid