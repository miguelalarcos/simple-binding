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

isSubClass = (klass, super_) ->
  klass.prototype instanceof super_

class Model
  @exclude = []
  constructor: (dct)->
    @schema = @constructor.schema
    @__computations = []
    for attr, value of @schema
      Object.defineProperty @, attr, getter_setter(@, '_' + attr)
    for k, sch of @schema
      v = dct[k]
      if v is undefined or v is null
        continue
      if _.isArray(v) and isSubClass(sch.type[0], Model) and not (v[0] instanceof sch.type[0])
        ret = []
        for a in v
          ret.push new sch.type[0](a)
        @[k] = ret
      if isSubClass(sch.type, Model) and not (v instanceof sch.type)
        @[k] = new sch.type(v)
      else
        @[k] = v

  toBDD: ->
    ret = {}
    for k, v of @schema
      if k in @constructor.exclude
        continue
      if _.isArray(v.type) and isSubClass(v.type[0], Model)
        ret[k] = []
        for x in @[k]
          ret[k].push x.toBDD()
      else if isSubClass(v.type, Model)
        ret[k] = @[k].toBDD()
      else
        ret[k] = @[k]
    ret

  save: ->
    if not @_id
      @_id = @constructor.collection.insert @toBDD()
    else
      @constructor.collection.update @_id, {$set: @toBDD()}

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
        ret[path + '.' + attr + '.validation'] = sch.validation(@[attr], @)
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

  subDoc: (path)->
    subdoc = @
    path = path.split('.')
    for p in path[...-1]
      if not _.isNaN(parseInt(p))
        p = parseInt(p)
      subdoc = subdoc[p]
      if subdoc is null or subdoc is undefined then return [null, '']
    return [subdoc, path[-1..][0]]

  destroy: ->
    for c in @__computations
      c.stop()

keyUpHelper = (self, el) ->
  (event) ->
    name = $(el).attr('sb-bind')
    [subdoc, name] = self.model.subDoc(name)
    prop = subdoc.constructor.schema[name]
    if prop.type is sb.Integer
      value = parseInt($(el).val())
      if value
        subdoc[name] = value
      else
        subdoc[name] = $(el).val()
    else if prop.type is sb.Float
      value = parseFloat($(el).val())
      if value
        subdoc[name] = value
      else
        subdoc[name] = $(el).val()
    else
      subdoc[name] = $(el).val()

dateChangeHelper = (self, el)->
  (event, param) ->
    name = $(el).attr('sb-datetime')
    [subdoc, name] = self.model.subDoc(name)
    subdoc[name] = param

dateHelper = (el, self, date)->
  ->
    [subdoc, name] = self.model.subDoc(date)
    if subdoc is null then return
    $(el).val subdoc[name]

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
    if subdoc is null then return
    $(el).val subdoc[name]

checkHelper = (el, self, check) ->
  ->
    [subdoc, name] = self.model.subDoc(check)
    if subdoc is null then return
    value = $(el).attr('value')
    if value in subdoc[name]
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
    if subdoc is null then return
    if subdoc[name]
      $(el).prop('checked', true)
    else
      $(el).prop('checked', false)

clickCustomBoolHelper = (self, el) ->
  (event) ->
    name = $(el).attr('sb-custom-bool')
    [subdoc, name] = self.model.subDoc(name)
    if $(el).val()
      subdoc[name] = false
    else
      subdoc[name] = true

customBoolHelper = (el, self, bool) ->
  ->
    [subdoc, name] = self.model.subDoc(bool)
    if subdoc is null then return
    if subdoc[name]
      $(el).val(true)
    else
      $(el).val(false)

disabledHelper = (el, self, disabled) ->
  ->
    [subdoc, name] = self.model.subDoc(disabled)
    if subdoc is null then return
    if subdoc[name]()
      $(el).prop("disabled", true)
    else
      $(el).prop("disabled", false)

visibleHelper = (el, self, visible)->
  ->
    [subdoc, name] = self.model.subDoc(visible)
    if subdoc is null then return
    if _.isFunction(subdoc[name])
      val = subdoc[name]()
    else
      val = subdoc[name]
    if val
      $(el).show() #removeClass("sb-invisible")
    else
      $(el).hide() #addClass("sb-invisible")

classesHelper = (el, self, classes) ->
  ->
    [subdoc, name] = self.model.subDoc(classes)
    if subdoc is null then return
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
    if subdoc is null then return
    value = subdoc[name]
    $(el).val(value)

radioHelper = (el, self, radio) ->
  ->
    [subdoc, name] = self.model.subDoc(radio)
    if subdoc is null then return
    value = $(el).attr('value')
    if value == subdoc[name]
      $(el).prop('checked', true)
    else
      $(el).prop('checked', false)

clickHelper = (el, self, click)->
  [subdoc, name] = self.model.subDoc(click)
  $(el).click ->
    subdoc[name]()

eventHelper = (el, self, event)->
  [event, f] = event.split(/\s+/)
  [subdoc, name] = self.model.subDoc(f)
  $(el).on event, (evt) ->
    subdoc[name](evt)

fadeHelper = (el, self, fade)->
  ->
    [subdoc, name] = self.model.subDoc(fade)
    if subdoc is null then return
    value = subdoc[name]()
    if value
      $(el).fadeIn()
    else
      $(el).fadeOut()

textHelper = (el, self, text)->
  ->
    [subdoc, name] = self.model.subDoc(text)
    if subdoc is null then return
    if _.isFunction(subdoc[name])
      $(el).text subdoc[name]()
    else
      $(el).text subdoc[name]

rebind = (t) ->
  self = t
  if self.model
    self.model.destroy()
  self.model = self.data.model
  if self.model is null then return

  all = t.findAll("[sb-template] [sb]")
  notValid = t.findAll("[sb-template] [sb-template] [sb]")
  for el in all
    if el in notValid
      continue
    elementBinds(el, self)

Template.withModel.helpers
  model: ->
    t = Template.instance()
    if t.parent().model isnt undefined and t.model != t.data.model
      rebind(t.parent())
    this.model

Template.sb_basic.hooks
  rendered: ->
    self = this
    self.model = self.data.model

    all = this.findAll("[sb-template] [sb]")
    notValid = this.findAll("[sb-template] [sb-template] [sb]")
    for el in all
      if el in notValid
        continue
      elementBinds(el, self)

  destroyed: ->
    if this.model
      this.model.destroy()

elementBinds = (el, self) ->
  text = $(el).attr('sb-text')
  if text
    self.model.__computations.push Tracker.autorun textHelper(el, self, text)
  fade = $(el).attr('sb-fade')
  if fade
    self.model.__computations.push Tracker.autorun fadeHelper(el, self, fade)
  click = $(el).attr('sb-click')
  if click
    clickHelper(el, self, click)
  events = $(el).attr('sb-events')
  if events
    for p in events.split(',')
      eventHelper(el, self, p.trim())
  hover = $(el).attr('sb-hover')
  if hover
    hoverHelper(el, self, hover)
  disabled = $(el).attr('sb-disabled')
  if disabled
    self.model.__computations.push Tracker.autorun disabledHelper(el, self, disabled)
  bind = $(el).attr('sb-bind')
  if bind
    $(el).bind 'keyup', keyUpHelper(self, el)
    self.model.__computations.push Tracker.autorun bindHelper(el, self, bind)
  #
  date = $(el).attr('sb-datetime')
  if date
    $(el).bind 'dateChange', dateChangeHelper(self, el)
    self.model.__computations.push Tracker.autorun dateHelper(el, self, date)
  #
  check = $(el).attr('sb-check')
  if check
    $(el).bind 'click', clickCheckHelper(self, el)
    self.model.__computations.push Tracker.autorun checkHelper(el, self, check)
  bool = $(el).attr('sb-bool')
  if bool
    $(el).bind 'click', clickBoolHelper(self, el)
    self.model.__computations.push Tracker.autorun boolHelper(el, self, bool)
  #
  custom_bool = $(el).attr('sb-custom-bool')
  if custom_bool
    $(el).bind 'click', clickCustomBoolHelper(self, el)
    self.model.__computations.push Tracker.autorun customBoolHelper(el, self, custom_bool)
  #
  visible = $(el).attr('sb-visible')
  if visible
    self.model.__computations.push Tracker.autorun visibleHelper(el, self, visible)
  radio = $(el).attr('sb-radio')
  if radio
    $(el).bind 'click', clickRadioHelper(self, el)
    self.model.__computations.push Tracker.autorun radioHelper(el, self, radio)
  select_ = $(el).attr("sb-select")
  if select_
    $(el).bind 'change', changeSelectHelper(self, el)
    self.model.__computations.push Tracker.autorun selectHelper(el, self, select_)
  classes = $(el).attr("sb-class")
  if classes
    self.model.__computations.push Tracker.autorun classesHelper(el, self, classes)
  focus = $(el).attr('sb-focus')
  if focus
    focusHelper(el, self, focus)

#sb = {}

sb.Model = Model
sb.reactiveArray = reactiveArray

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
      self.model.__computations.push Tracker.autorun dropdowntHelper(el, self, select_)
###