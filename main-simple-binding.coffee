sb = {}

class Integer
class Float

sb.Integer = Integer
sb.Float = Float

sb.validate = (object, schema) ->
  if Meteor.isServer
    for attr of object
      if attr not in _.keys(schema) #(x for x of schema) # _.keys
        return false

  for attr, sch of schema
    value = object[attr]
    if not sch.optional and (value is undefined or value is null or value == '')
      return false
    if sch.optional and (value is undefined or value is null or value == '')
      continue
    #if value isnt undefined and value isnt null and value != ''
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

