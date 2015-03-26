$.valHooks['customCheck'] =
  get: (el)->
    $(el).find('input').prop('checked')
  set: (el, value)->
    $(el).find('input').prop('checked', value)

$.fn.customCheck = (name)->
  this.each ->
    this.type = 'customCheck'
  this

Template.customCheck.rendered = ->
  $(this.find('.customCheck')).customCheck()