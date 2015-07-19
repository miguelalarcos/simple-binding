_isValidAutocomplete = new ReactiveDict()

sb.isValidAutocomplete = (id) -> _isValidAutocomplete.get(id)

_setValidAutocomplete = (id, value) -> _isValidAutocomplete.set(id, value)

sb.resetValidationAutocomplete = (tagId, id) ->
  if id
    _setValidAutocomplete(tagId, true)
  else
    _setValidAutocomplete(tagId, false)

# query is Reactive var where we are going to keep the text that the user is writing in the current autocomplete input
query = new ReactiveVar('')

# we are going to keep the items to show in the popover as the user is writing in the autocomplete input
items = new Meteor.Collection null

# index is the index in the popover where the user click
index = -1

# the path of the current autocomplete input where the user is typing
current_input = null

generalRenderFunction = (key)->
  (x, query)->
    txt = '<td>' +x[key]+ '</td>'
    #txt.replace(query, "<b>$&</b>")

Template.sbAutocomplete.helpers

# this is reactive based on query Reactive var. It makes a call to the server to get the items of the popover
  items: ->
    query_ = query.get()
    atts = this
    call = atts.call
    #collection = atts.collection
    renderFunction = atts.renderFunction
    if renderFunction
      renderFunction = window[renderFunction]
    else
      renderFunction = generalRenderFunction(atts.renderKey)

    if atts.id == current_input # and query_ != ''
      Meteor.call call, query_, (error, result)->
        items.remove({})
        _isValidAutocomplete.set(atts.id, false)
        result = _.sortBy(result, atts.fieldRef)
        for item, i in result
          rendered = renderFunction(item, query_)
          value = item[atts.fieldRef]
          if value == query_
            _isValidAutocomplete.set(atts.id, true)
          items.insert({value: value, content:rendered, index: i, remote_id: item._id, doc: item})

      items.find({})
    else
      null

Template.sbAutocomplete.events
  'click .xitem':(e,t)->
    index = $(e.currentTarget).attr('index')
    items.update({},{$set:{selected: ''}})
    items.update({index: parseInt(index)}, {$set:{selected: 'xselected'}})
    selected = items.findOne({selected: 'xselected'})
    $(t.find '.xautocomplete-input').val(selected.value)
    widget = t.find('.xwidget')
    _isValidAutocomplete.set($(widget).attr('id'), true)
    $(widget).trigger('textChange', [selected.value])
    items.remove({})
    #query.set('')
    index = -1

  'keyup .xautocomplete-input': (e,t)->
    Dropdowns.show(t.data.id)
    if e.keyCode == 38
      items.update({index:index}, {$set:{selected: ''}}) # items.update({}, {$set:{selected: ''}})
      if index == -1 then index = -1 else index -= 1
      items.update({index:index}, {$set:{selected: 'xselected'}})
    else if e.keyCode == 40
      items.update({index:index}, {$set:{selected: ''}})
      count = items.find({}).count() - 1
      if index == count then index = 0 else index += 1
      items.update({index:index}, {$set:{selected: 'xselected'}})
    else if e.keyCode in [13, 39]
      selected = items.findOne({selected: 'xselected'}) or items.findOne({index: 0})
      $(e.target).val(selected.value)
      items.remove({})
      #query.set('')
      index = -1
      widget = t.find('.xwidget')
      _isValidAutocomplete.set($(widget).attr('id'), true)
      $(widget).trigger('textChange', [selected.value])
    else if e.keyCode == 27
      items.remove({})
      #query.set('')
      index = -1
    else
      val = $(e.target).val()
      query.set(val)
      widget = t.find('.xwidget')
      $(widget).trigger('textChange', [val])

  'focusin .xautocomplete-input': (e,t) ->
    val = $(e.target).val()
    query.set('')
    query.set(val)
    current_input = t.data.id

  'focusout .xautocomplete': (e,t)->
    if not $(e.relatedTarget).is('.xpopover')
      items.remove({})
      #query.set('')
      index = -1

$.valHooks['sbautocomplete'] =
  get : (el)->
    $(el).val()

  set : (el, value)->
    el = $(el).find('.xautocomplete-input')
    $(el).val(value)

$.fn.sbautocomplete = ->
  this.each -> this.type = 'sbautocomplete'
  this

Template.sbAutocomplete.rendered = ->
  $(this.findAll('.xautocomplete')).sbautocomplete()
  #
  #el = this.find('.xautocomplete')
  #input = $(el).find('.xautocomplete-input')
  #popover = $(el).find('.xpopover')
  #offset = input.offset()
  #popover.offset({top: offset.top + input.height(), left: offset.left})
