keyUpHelper = (self, el) -> # =>
  (event) ->
    name = $(el).attr('bind')
    self.model[name] = $(el).val()

clickCheckHelper = (self, el)->
  (event) ->
    name = $(el).attr('check')
    if $(el).is(':checked')
      ret = (x for x in self.model[name]) #usar [..]
      ret.push $(el).attr('value')
      self.model[name] = ret
    else
      ret = (x for x in self.model[name] when x != $(el).attr('value'))
      self.model[name] = ret

bindHelper = (el, self, bind) ->
  -> $(el).val(self.model[bind])

checkHelper = (el, self, check) ->
  ->
    value = $(el).attr('value')
    if value in self.model[check]
      $(el).prop('checked', true)
    else
      $(el).prop('checked', false)

disabledHelper = (el, self, disabled) ->
  ->
    if self.model[disabled]()
      $(el).prop( "disabled", true )
    else
      $(el).prop( "disabled", false )

Template.basic.hooks
  rendered: ->
    self = this
    for el in this.findAll("[sb]")
      hover = $(el).attr('hover')
      if hover
        $(el).hover((->self.model[hover]=true), (->self.model[hover]=false))
      disabled = $(el).attr('disabled_')
      if disabled
        Tracker.autorun disabledHelper(el, self, disabled)
      bind = $(el).attr('bind')
      if bind
        $(el).bind 'keyup', keyUpHelper(self, el)
        Tracker.autorun bindHelper(el, self, bind)
      check = $(el).attr('check')
      if check
        $(el).bind 'click', clickCheckHelper(self, el)
        Tracker.autorun checkHelper(el, self, check)



argsToList = (args)->
  ret = []
  for k, i in args
    if 0 < i < args.length-1
      ret.push k
  ret

Template.basic.helpers
  text: (prop)->
    model = UI._templateInstance().model
    if _.isFunction(model[prop])
      args = argsToList(arguments)
      model[prop].apply(model, args)
    else
      model[prop]
