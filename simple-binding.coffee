getter_setter = (obj, attr) ->
  dep = new Tracker.Dependency()
  get: ->
    dep.depend()
    obj[attr]
  set: (value) ->
    if value != obj[attr]
      dep.changed()
      obj[attr] = value

class BaseReactive
  constructor: (dct)->
    for attr, value of @constructor.schema
      Object.defineProperty @, attr, getter_setter(@, '_' + attr)
    for k, v of dct
      @['_' + k] = v
  subDoc: (path)->
    subdoc = @
    path = path.split('.')
    for p in path[...-1]
      subdoc = subdoc[p]
    return [subdoc, path[-1..][0]]

keyUpHelper = (self, el) ->
  (event) ->
    name = $(el).attr('bind')
    [subdoc, name] = self.model.subDoc(name)
    subdoc[name] = $(el).val()

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
  ->
    [subdoc, name] = self.model.subDoc(bind)
    $(el).val subdoc[name]

checkHelper = (el, self, check) ->
  ->
    value = $(el).attr('value')
    if value in self.model[check]
      $(el).prop('checked', true)
    else
      $(el).prop('checked', false)

disabledHelper = (el, self, disabled) ->
  ->
    [subdoc, name] = self.model.subDoc(disabled)
    #if self.model[disabled]()
    if subdoc[name]()
      $(el).prop( "disabled", true )
    else
      $(el).prop( "disabled", false )

visibleHelper = (el, self, visible)->
  ->
    if self.model[visible]()
      $(el).removeClass( "invisible")
    else
      $(el).addClass("invisible")

hoverHelper = (el, self, hover)->
  $(el).hover((->self.model[hover]=true), (->self.model[hover]=false))

clickRadioHelper = (self, el)->
  (event) ->
    name = $(el).attr('radio')
    value = $(el).attr('value')
    self.model[name] = value

radioHelper = (el, self, radio) ->
  ->
    value = $(el).attr('value')
    if value == self.model[radio]
      $(el).prop('checked', true)
    else
      $(el).prop('checked', false)

clickHelper = (el, self, click)->
  $(el).click ->
    self.model[click]()

fadeHelper = (el, self, fade)->
  ->
    value = self.model[fade]
    if value
      $(el).fadeIn()
    else
      $(el).fadeOut()

Template.basic.hooks
  rendered: ->
    self = this
    for el in this.findAll("[sb]")
      fade = $(el).attr('fade')
      if fade
        Tracker.autorun fadeHelper(el, self, fade)
      click = $(el).attr('click')
      if click
        clickHelper(el, self, click)
      hover = $(el).attr('hover')
      if hover
        hoverHelper(el, self, hover)
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
      visible = $(el).attr('visible')
      if visible
        Tracker.autorun visibleHelper(el, self, visible)
      radio = $(el).attr('radio')
      if radio
        $(el).bind 'click', clickRadioHelper(self, el)
        Tracker.autorun radioHelper(el, self, radio)

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
