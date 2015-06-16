sb = {}

class Integer
class Float

sb.Integer = Integer
sb.Float = Float

sb.validate = (object, schema) ->
  if Meteor.isServer
    for attr of object
      if attr not in (x for x of schema) # _.keys
        return false
  for attr, sch of schema
    value = object[attr]
    if not sch.optional and value is undefined # null, ''?
      return false
    if value isnt undefined
      if sch.type == String and not _.isString(value)
        return false
      else if (sch.type == Integer or sch.type == Float) and not _.isNumber(value)
        return false
      else if sch.type == Boolean and not _.isBoolean(value)
        return false
      else if sch.type == Date and not _.isDate(value)
        return false
      #else if isSubClass(sch.type, Model) # en lugar de Model debe ser _.isObject
      else if _.isObject(value)
        if not validate(value, sch) then return false
        continue
    if sch.validation
      if not sch.validation(value, @) then return false

  return true