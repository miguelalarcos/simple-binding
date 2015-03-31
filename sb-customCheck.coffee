$.valHooks['customCheck'] =
  get: (el)->
    $(el).find('input').prop('checked')
  set: (el, value)->
    $(el).find('input').prop('checked', value)

$.fn.customCheck = (name)->
  this.each ->
    this.type = 'customCheck'
  this

Template.sbCustomCheck.rendered = ->
  el = $(this.find('.customCheck'))
  el.customCheck()
  el.addClass el.attr('sb-customcheck-class')