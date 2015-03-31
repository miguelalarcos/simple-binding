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
    for k, v of dct
      if k in @constructor.exclude
        continue
      if k != '_id' and isSubClass(@schema[k].type, Model)
        @[k] = new @schema[k].type(v)
      else
        @[k] = v

  _validate: (ret, path) ->
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
        ret[path + '.' + attr + '.validation'] = sch.validation(@[attr])
    ret

  validate: (ret, path) ->
    if not ret
      ret = {}
      path = ''
    @_validate(ret, path)
    if @validation
      ret[path + '.validation'] = @validation()
    ret

  isValid: ->
    for k, v of @validate()
      if not v
        return false
    return true

  isNotValid: -> not @isValid()

sb.Model = Model