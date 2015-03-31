$.valHooks['customBool'] =
  get: (el)->
    $(el).find('input').prop('checked')
  set: (el, value)->
    $(el).find('input').prop('checked', value)

$.fn.customBool = (name)->
  this.each ->
    this.type = 'customBool'
  this

Template.sbCustomBool.events
  'click .xwidget': (e,t)->
    el = t.find('input[type=checkbox]')
    value = $(el).prop('checked')
    widget = t.find('.xwidget')
    $(widget).trigger('dateChange', [not value])

Template.sbCustomBool.rendered = ->
  el = $(this.find('.customBool'))
  el.customBool()
  el.addClass el.attr('sb-custombool-class')