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
      if not _.isNaN(parseInt(p))
        p = parseInt(p)
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
    [subdoc, name] = self.model.subDoc(name)
    if $(el).is(':checked')
      ret = (x for x in self.model[name]) #usar [..]
      ret.push $(el).attr('value')
      #self.model[name] = ret
      subdoc[name] = ret
    else
      ret = (x for x in self.model[name] when x != $(el).attr('value'))
      #self.model[name] = ret
      subdoc[name] = ret

bindHelper = (el, self, bind) ->
  ->
    [subdoc, name] = self.model.subDoc(bind)
    $(el).val subdoc[name]

checkHelper = (el, self, check) ->
  ->
    [subdoc, name] = self.model.subDoc(check)
    value = $(el).attr('value')
    if value in subdoc[name] #self.model[check]
      $(el).prop('checked', true)
    else
      $(el).prop('checked', false)

disabledHelper = (el, self, disabled) ->
  ->
    [subdoc, name] = self.model.subDoc(disabled)
    if subdoc[name]()
      $(el).prop("disabled", true)
    else
      $(el).prop("disabled", false)

visibleHelper = (el, self, visible)->
  ->
    [subdoc, name] = self.model.subDoc(visible)
    if subdoc[name]() #self.model[visible]()
      $(el).removeClass("invisible")
    else
      $(el).addClass("invisible")

hoverHelper = (el, self, hover)->
  [subdoc, name] = self.model.subDoc(hover)
  #$(el).hover((->self.model[hover]=true), (->self.model[hover]=false))
  $(el).hover((->subdoc[name]=true), (->subdoc[name]=false))

clickRadioHelper = (self, el)->
  (event) ->
    name = $(el).attr('radio')
    value = $(el).attr('value')
    [subdoc, name] = self.model.subDoc(name)
    subdoc[name] = value
    #self.model[name] = value

changeSelectHelper = (self, el)->
  (event) ->
    name = $(el).attr('select_')
    value = $(el).val()
    [subdoc, name] = self.model.subDoc(name)
    subdoc[name] = value

selectHelper = (el, self, select_) ->
  ->
    [subdoc, name] = self.model.subDoc(select_)
    value = subdoc[name]
    $(el).val(value)

radioHelper = (el, self, radio) ->
  ->
    [subdoc, name] = self.model.subDoc(radio)
    value = $(el).attr('value')
    if value == subdoc[name]#self.model[radio]
      $(el).prop('checked', true)
    else
      $(el).prop('checked', false)

clickHelper = (el, self, click)->
  [subdoc, name] = self.model.subDoc(click)
  $(el).click ->
    #self.model[click]()
    subdoc[name]()

fadeHelper = (el, self, fade)->
  ->
    [subdoc, name] = self.model.subDoc(fade)
    #value = self.model[fade]
    value = subdoc[name]()
    if value
      $(el).fadeIn()
    else
      $(el).fadeOut()

textHelper = (el, self, text)->
  ->
    [subdoc, name] = self.model.subDoc(text)
    if _.isFunction(subdoc[name])
      $(el).text subdoc[name]()
    else
      $(el).text subdoc[name]

Template.sb_basic.hooks
  rendered: ->
    self = this
    for el in this.findAll("[sb]")
      text = $(el).attr('text')
      if text
        Tracker.autorun textHelper(el, self, text)
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
      select_ = $(el).attr("select_")
      if select_
        $(el).bind 'change', changeSelectHelper(self, el)
        Tracker.autorun selectHelper(el, self, select_)
