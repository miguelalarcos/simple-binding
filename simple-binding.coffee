helper = (self, el) =>
  (event) -> self.model[$(el).attr('name')] = $(el).val()

helperCheckbox = (self, el)->
  (event) ->
    if $(el).is(':checked')
      ret = (x for x in self.model[$(el).attr('name')]) #usar [..]
      ret.push $(el).attr('value')
      self.model[$(el).attr('name')] = ret
    else
      ret = (x for x in self.model[$(el).attr('name')] when x != $(el).attr('value'))
      self.model[$(el).attr('name')] = ret

Template.basic.hooks
  rendered: ->
    self = this
    for el in this.findAll("[sb]")
      type = $(el).attr('type')
      if type == 'text'
        $(el).bind 'keyup', helper(self, el)
      else if type == 'checkbox'
        $(el).bind 'click', helperCheckbox(self, el)

argsToList = (args)->
  ret = []
  for k, i in args
    if 0 < i < args.length-1
      ret.push k
  ret

Template.basic.helpers
  disabled: (prop)->
    model = UI._templateInstance().model
    disabled = model[prop]()
    if disabled
      {disabled: true}
    else
      ''
  bind: (prop) ->
    model = UI._templateInstance().model
    {value: model[prop], name: prop, sb:true}
  text: (prop)->
    model = UI._templateInstance().model
    if _.isFunction(model[prop])
      args = argsToList(arguments)
      model[prop].apply(model, args)
    else
      model[prop]
  check: (prop, value) ->
    model = UI._templateInstance().model
    valueIn = value in model[prop]
    if valueIn
      {name: prop, value:value, checked: 'checked', sb:true}
    else
      {name: prop, value:value, checked: undefined, sb:true}