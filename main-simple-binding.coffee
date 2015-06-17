sb = {}

class Integer
class Float

sb.Integer = Integer
sb.Float = Float

sb.validate = (object, schema) ->
  if Meteor.isServer
    for attr of object
      if attr not in (x for x of schema) # _.keys
        console.log attr, (x for x of schema), schema
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
      else if _.isArray(value)
        for v in value
          console.log sch.type, sch.type[0]
          if not sb.validate(v, sch.type[0]) then return false
        continue
      else if _.isObject(value)
        console.log sch.type
        if not sb.validate(value, sch.type) then return false
        continue
    if sch.validation
      if not sch.validation(value, @) then return false

  return true

class Schema
  constructor: (dct)->
    for k, v of dct
      @[k] = v

sb.Schema = Schema