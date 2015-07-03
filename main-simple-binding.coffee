sb = {}

class Integer
class Float

sb.Integer = Integer
sb.Float = Float

empty = (value) ->
  if _.isDate(value)
    return false
  if value is undefined or value is null or value == '' or (_.isObject(value) and _.isEmpty(value))
    true
  else
    false

sb.validate = (object, schema) ->
  if Meteor.isServer
    keys = _.keys(schema)
    for attr of object
      if attr not in keys
        return false

  for attr, sch of schema
    value = object[attr]
    if not sch.optional and empty(value)
      return false
    if sch.optional and empty(value)
      continue

    if sch.type == String and not _.isString(value)
      return false
    else if (sch.type == Integer or sch.type == Float) and not _.isNumber(value)
      return false
    else if sch.type == Boolean and not _.isBoolean(value)
      return false
    else if sch.type == Date and not _.isDate(value)
      return false
    else if _.isArray(value)
      for v in value
        if not sb.validate(v, sch.type[0].schema) then return false
      continue
    else if _.isObject(value)
      if not sb.validate(value, sch.type.schema) then return false
      continue
    if sch.validation
      if not sch.validation(value, @) then return false

  return true

