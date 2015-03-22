reactiveArray = (v, dep) ->
  if dep is undefined
    dep = new Tracker.Dependency()

  push = v.push
  v.push = (x) ->
    dep.changed()
    push.apply v, [x]

  pop = v.pop
  v.pop = ->
    dep.changed()
    pop.apply v

  shift = v.shift
  v.shift = ->
    dep.changed()
    shift.apply v

  unshift = v.unshift
  v.unshift = (x)->
    dep.changed()
    unshift.apply v, [x]

  splice = v.splice
  v.splice = (pos, n, args...)->
    dep.changed()
    splice.apply v, [pos, n].concat(args)

  v.set = (pos, value) ->
    dep.changed()
    v[pos] = value

  v.depend = ->
    dep.depend()

  v.wrapped = true
  return v

getter_setter = (obj, attr) ->
  dep = new Tracker.Dependency()
  get: ->
    dep.depend()
    obj[attr]
  set: (value) ->
    if _.isArray(value) and not value.wrapped
      value = reactiveArray(value, dep)
    if value != obj[attr]
      dep.changed()
      obj[attr] = value

class BaseReactive
  constructor: (dct)->
    for attr, value of @constructor.schema
      Object.defineProperty @, attr, getter_setter(@, '_' + attr)
    for k, v of dct
      @[k] = v

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
    name = $(el).attr('sb-bind')
    [subdoc, name] = self.model.subDoc(name)
    subdoc[name] = $(el).val()

clickCheckHelper = (self, el)->
  (event) ->
    name = $(el).attr('sb-check')
    [subdoc, name] = self.model.subDoc(name)
    if $(el).is(':checked')
      ret = (x for x in self.model[name]) #usar [..]
      ret.push $(el).attr('value')
      subdoc[name] = ret
    else
      ret = (x for x in self.model[name] when x != $(el).attr('value'))
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

clickBoolHelper = (self, el) ->
  (event) ->
    name = $(el).attr('sb-bool')
    [subdoc, name] = self.model.subDoc(name)
    if $(el).is(':checked')
      subdoc[name] = true
    else
      subdoc[name] = false

boolHelper = (el, self, bool) ->
  ->
    [subdoc, name] = self.model.subDoc(bool)
    if subdoc[name]
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
    if subdoc[name]()
      $(el).removeClass("sb-invisible")
    else
      $(el).addClass("sb-invisible")

classesHelper = (el, self, classes) ->
  ->
    [subdoc, name] = self.model.subDoc(classes)
    $(el).removeClass()
    $(el).addClass(subdoc[name]())

hoverHelper = (el, self, hover)->
  [subdoc, name] = self.model.subDoc(hover)
  $(el).hover((->subdoc[name]=true), (->subdoc[name]=false))

focusHelper = (el, self, focus)->
  [subdoc, name] = self.model.subDoc(focus)
  $(el).focus(->subdoc[name]=true)
  $(el).focusout(->subdoc[name]=false)

clickRadioHelper = (self, el)->
  (event) ->
    name = $(el).attr('sb-radio')
    value = $(el).attr('value')
    [subdoc, name] = self.model.subDoc(name)
    subdoc[name] = value
    #self.model[name] = value

changeSelectHelper = (self, el)->
  (event) ->
    name = $(el).attr('sb-select')
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

Template.sb_basic.helpers
  model: ->
    model = UI._templateInstance().model
    model.__path = ''
    model
  subModel: (path) ->
    model = UI._templateInstance().model
    [doc, name] = model.subDoc(path)
    doc[name].__path = path
    doc[name]
  path: (attr)->
    this.__path + '.' + attr
  list: (name)->
    path = this.__path + '.' + name
    if /^\./.test(path) then path = path[1..]
    for elem, i in this[name]
      elem.__path = path + '.' + i
    this[name]

Template.sb_basic.hooks
  created: ->
    this.computations = []
  rendered: ->
    self = this
    #for c in self.computations
    #  c.stop()
    #self.computations = []
    for el in this.findAll("[sb]")
      text = $(el).attr('sb-text')
      if text
        self.computations.push Tracker.autorun textHelper(el, self, text)
      fade = $(el).attr('sb-fade')
      if fade
        self.computations.push Tracker.autorun fadeHelper(el, self, fade)
      click = $(el).attr('sb-click')
      if click
        clickHelper(el, self, click)
      hover = $(el).attr('sb-hover')
      if hover
        hoverHelper(el, self, hover)
      disabled = $(el).attr('sb-disabled')
      if disabled
        self.computations.push Tracker.autorun disabledHelper(el, self, disabled)
      bind = $(el).attr('sb-bind')
      if bind
        $(el).bind 'keyup', keyUpHelper(self, el)
        self.computations.push Tracker.autorun bindHelper(el, self, bind)
      check = $(el).attr('sb-check')
      if check
        $(el).bind 'click', clickCheckHelper(self, el)
        self.computations.push Tracker.autorun checkHelper(el, self, check)
      bool = $(el).attr('sb-bool')
      if bool
        $(el).bind 'click', clickBoolHelper(self, el)
        self.computations.push Tracker.autorun boolHelper(el, self, bool)
      visible = $(el).attr('sb-visible')
      if visible
        self.computations.push Tracker.autorun visibleHelper(el, self, visible)
      radio = $(el).attr('sb-radio')
      if radio
        $(el).bind 'click', clickRadioHelper(self, el)
        self.computations.push Tracker.autorun radioHelper(el, self, radio)
      select_ = $(el).attr("sb-select")
      if select_
        $(el).bind 'change', changeSelectHelper(self, el)
        self.computations.push Tracker.autorun selectHelper(el, self, select_)
      classes = $(el).attr("sb-class")
      if classes
        self.computations.push Tracker.autorun classesHelper(el, self, classes)
      focus = $(el).attr('sb-focus')
      if focus
        focusHelper(el, self, focus)

  destroyed: ->
    for c in this.computations
      c.stop()
###
dropdownChangeHelper = (self, el)->
  (value, text) ->
    name = $(el).attr('sb-dropdown')
    [subdoc, name] = self.model.subDoc(name)
    subdoc[name] = value

dropdowntHelper = (el, self, select_) ->
  ->
    [subdoc, name] = self.model.subDoc(select_)
    value = subdoc[name]
    $(el).dropdown('set text', value)

Template.sb_basic.hooks
  rendered: ->
    self = this
    for el in this.findAll("[sb].ui.dropdown")
      select_ = $(el).attr("sb-dropdown")
      $(el).dropdown
        onChange: dropdownChangeHelper(self, el)
      self.computations.push Tracker.autorun dropdowntHelper(el, self, select_)
###