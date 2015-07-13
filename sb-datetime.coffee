show_calendar = new ReactiveVar(false) #it is only used at the beginning of the app. Later it's used .hide() and .show()
# the reason is that to render the calendar we need data from the template, that is not already rendered.

isLocalRepeated = (m) ->
  dateLocal = m
  dateLocalMinus1h = m.clone().add(-1, 'hours')
  if dateLocal.format('HH') == dateLocalMinus1h.format('HH')
    true
  else
    false

getMomentFromTemplate = (t)->
  el = t.find('.xdatetime')
  $(el).data('moment').get()

Template.sbDateTime.events
  'focusout .xdatetime-input': (e,t)->
    atts = t.data
    txtdate = $(t.find('.xdatetime-input')).val()
    date = moment(txtdate, atts.format, true)
    if not date.isValid()
      if atts.time
        date = moment()
      else
        date = moment().startOf('day')
    widget = t.find('.xwidget')
    $(widget).trigger('dateChange', [date.toDate()])

  'click .show-calendar': (e, t)->
    show_calendar.set true
    all_pops = $('body').find('.xdatetime-popover').get()
    current = t.find('.xdatetime-popover')
    for pop in all_pops
      if pop != current
        $(pop).hide()
    $(current).toggle()
    if not $(current).is(':visible')
      show_calendar.set false

  'click .xdatetime-day': (e, t)->
    atts = t.data
    if atts.time == true
      value = getMomentFromTemplate(t).format('HH:mm')
      date = this.date + ' ' + value
    else
      date = this.date
    m_ = moment(date, 'YYYY-MM-DD HH:mm')
    widget = t.find('.xwidget')
    $(widget).trigger('dateChange', [m_.toDate()])
    unless atts.time == true
      current = t.find('.xdatetime-popover')
      $(current).hide()
      show_calendar.set false

  'click .minus-month': (e,t)->
    date = getMomentFromTemplate(t)
    date.subtract(1, 'months')
    widget = t.find('.xwidget')
    $(widget).trigger('dateChange', [date.toDate()])

  'click .plus-month': (e,t)->
    date = getMomentFromTemplate(t)
    date.add(1, 'months')
    widget = t.find('.xwidget')
    $(widget).trigger('dateChange', [date.toDate()])

  'click .minus-year': (e,t)->
    date = getMomentFromTemplate(t)
    date.subtract(1, 'years')
    widget = t.find('.xwidget')
    $(widget).trigger('dateChange', [date.toDate()])

  'click .plus-year': (e,t)->
    date = getMomentFromTemplate(t)
    date.add(1, 'years')
    widget = t.find('.xwidget')
    $(widget).trigger('dateChange', [date.toDate()])

  'click .minus-hour': (e,t)->
    date = getMomentFromTemplate(t)
    date.subtract(1, 'hours')
    widget = t.find('.xwidget')
    $(widget).trigger('dateChange', [date.toDate()])

  'click .plus-hour': (e,t)->
    date = getMomentFromTemplate(t)
    date.add(1, 'hours')
    widget = t.find('.xwidget')
    $(widget).trigger('dateChange', [date.toDate()])

  'click .minus-minute': (e,t)->
    date = getMomentFromTemplate(t)
    date.subtract(1, 'minutes')
    widget = t.find('.xwidget')
    $(widget).trigger('dateChange', [date.toDate()])

  'click .plus-minute': (e,t)->
    date = getMomentFromTemplate(t)
    date.add(1, 'minutes')
    widget = t.find('.xwidget')
    $(widget).trigger('dateChange', [date.toDate()])


dayRow = (week, date)->
  ret = []
  day = date.clone()
  ini_month = day.clone().startOf('Month')
  ini = day.clone().startOf('Month').add(1-ini_month.isoWeekday(), 'days')

  ini = ini.add(week, 'weeks')

  dt = ini_month.clone().add(1, 'month')
  if ini.isAfter(dt) or ini.isSame(dt)
    return []
  end = ini.clone().add(7, 'days')

  while not ini.isSame(end)
    if ini_month.format('MM') == ini.format('MM')
      if ini.isSame(moment().startOf('day'))
        decoration = 'xbold xunderline xtoday'
      else
        decoration = 'xbold'
    else
      decoration = 'xcursive'

    ret.push {value: ini.format('DD'), date: ini.format('YYYY-MM-DD'), decoration: decoration}
    ini.add(1, 'days')
  ret

Template.sbDateTime.helpers
  show_calendar: ->
    show_calendar.get()

  show_time: ->
    atts = this
    atts.time == true

  time: ->
    t = Template.instance()
    el = t.find('.xdatetime')
    $(el).data('moment').get().format('HH:mm')

  year: ->
    t = Template.instance()
    el = t.find('.xdatetime')
    $(el).data('moment').get().format('YYYY')

  month: ->
    t = Template.instance()
    el = t.find('.xdatetime')
    $(el).data('moment').get().format('MM')

  week: -> (i for i in [0...6])

  day: (week) ->
    t = Template.instance()
    el = t.find('.xdatetime')
    date = $(el).data('moment').get()
    dayRow(week, date.clone())

  checkDST: ->
    t = Template.instance()
    el = t.find('.xdatetime')
    date = $(el).data('moment').get()
    if isLocalRepeated date.clone() then 'red' else ''


$.valHooks['sbdatetime'] =
  get: (el)->
    txt = $(el).find('.xdatetime-input').val()
    format = $(el).attr('format')
    return moment(txt, format).toDate()

  set: (el, value)->
    format = $(el).attr('format')
    time = $(el).attr('time')
    m = moment(value)
    if not m.isValid()
      if time
        m = moment()
      else
        m = moment().startOf('day')
    $(el).find('.xdatetime-input').val(m.format(format))  #(moment(value).format(format))
    $(el).data('moment').set(m)  #(moment(value))

$.fn.sbdatetime = (name)->
  this.each ->
    this.type = 'sbdatetime'
  this

Template.sbDateTime.rendered = ->
  $(this.find('.xwidget')).sbdatetime()
  for el in this.findAll('.xwidget.xdatetime')
    $(el).data('moment', new ReactiveVar())
    $(el).find('.xdatetime-popover').hide()
    #
    #input = $(el).find('.xdatetime-input')
    #popover = $(el).find('.xdatetime-popover')
    #popover.offset({top: input.height(), left: 0})