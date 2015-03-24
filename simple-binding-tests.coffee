Template.testBindings.inheritsHooksFrom("sb_basic")
Template.nested.inheritsHooksFrom("sb_basic")

Template.testBindings.helpers
  echo: (x)->console.log x

class B extends BaseReactive
  @schema:
    flag:
      type: Boolean
  show: -> (@flag and 'hola') or ''

class A extends BaseReactive
  @schema:
    first:
      type: String
    cinema:
      type: [String]
    flag:
      type: Boolean
    sex:
      type: String
    nested:
      type: B

model = new A
  first: 'miguel'
  cinema: ['miguel']
  flag: true
  sex: 'male'
  nested: new B
    flag: true

describe 'binding suite', ->
  el = null
  beforeAll ->
    el = Blaze.renderWithData(Template.testBindings, {model: model},$('body')[0])
    Meteor.flush()
  afterAll ->
    Blaze.remove(el)

  it 'test bind', (test)->
    test.equal model.first, $("body").find("#0").val()
    $("body").find("#0").val('veronica')
    $("body").find("#0").trigger('keyup')
    test.equal model.first, 'veronica'
    model.first = 'bernardo'
    Meteor.flush()
    test.equal model.first, $("body").find("#0").val()

  it 'test select multiple', (test)->
    test.equal model.cinema, $("body").find("#1").val()
    $("body").find("#1").val('bernardo')
    $("body").find("#1").trigger('change')
    test.equal model.cinema, ['bernardo']
    model.cinema = ['miguel', 'veronica']
    Meteor.flush()
    test.equal model.cinema, $("body").find("#1").val()

  it 'test check', (test)->
    test.isTrue $("body").find("#2").is(':checked')
    test.isTrue 'miguel' in model.cinema
    $("body").find("#2").trigger('click')
    test.isTrue 'miguel' not in model.cinema
    model.cinema = ['miguel', 'veronica']
    Meteor.flush()
    test.isTrue $("body").find("#2").is(':checked')

  it 'test bool', (test)->
    test.isTrue $("body").find("#3").is(':checked')
    $("body").find("#3").trigger('click')
    test.isFalse model.flag
    model.flag = true
    Meteor.flush()
    test.isTrue $("body").find("#3").is(':checked')

  it 'test select single', (test)->
    test.equal model.first, $("body").find("#4").val()
    $("body").find("#4").val('bernardo')
    $("body").find("#4").trigger('change')
    test.equal model.first, 'bernardo'
    model.first = 'veronica'
    Meteor.flush()
    test.equal model.first, $("body").find("#4").val()

  it 'test radio', (test) ->
    test.isTrue $("body").find("#5").is(':checked')
    test.isFalse $("body").find("#6").is(':checked')
    $("body").find("#6").trigger('click')
    test.equal model.sex, 'female'
    model.sex = 'male'
    Meteor.flush()
    test.isTrue $("body").find("#5").is(':checked')

  it 'test text nested', (test) ->
    model.nested.flag = false
    Meteor.flush()
    test.equal $("body").find("#7").text(), ''
    model.nested.flag = true
    Meteor.flush()
    test.equal $("body").find("#7").text(), 'hola'

describe 'suite to test reactiveArray', ->
  it 'test set', (test)->
    value = null
    c = Tracker.autorun ->
      value = model.cinema[0]
    model.cinema.set(0, 'bernardo')
    Meteor.flush()
    test.equal value, 'bernardo'
    c.stop()

  it 'test push', (test)->
    model.cinema = []
    value = null
    c = Tracker.autorun ->
      value = model.cinema[0]
    model.cinema.push 'veronica'
    Meteor.flush()
    test.equal value, 'veronica'
    c.stop()

  it 'test splice as remove', (test)->
    model.cinema = ['miguel', 'veronica']
    value = null
    c = Tracker.autorun ->
      value = model.cinema[0]
    model.cinema.splice 0,1
    Meteor.flush()
    test.equal value, 'veronica'
    c.stop()

  it 'test pop', (test)->
    model.cinema = ['miguel', 'veronica']
    value = null
    c = Tracker.autorun ->
      value = model.cinema[0]
    model.cinema.pop
    Meteor.flush()
    test.equal value, 'miguel'
    c.stop()

  it 'test shift', (test)->
    model.cinema = ['miguel', 'veronica']
    value = null
    c = Tracker.autorun ->
      value = model.cinema[0]
    model.cinema.shift()
    Meteor.flush()
    test.equal value, 'veronica'
    c.stop()

  it 'test unshift', (test)->
    model.cinema = []
    value = null
    c = Tracker.autorun ->
      value = model.cinema[0]
    model.cinema.unshift 'miguel'
    Meteor.flush()
    test.equal value, 'miguel'
    c.stop()

describe 'complex actions suite', ->
  el = null
  beforeAll ->
    el = Blaze.renderWithData(Template.testBindings, {model: model},$('body')[0])
    Meteor.flush()
  afterAll ->
    Blaze.remove(el)

  it 'test destroy simple', (test)->
    nested = model.nested
    stubs.create 'nested_destroy', nested, 'destroy'
    model.nested = new B
      flag: true
    Meteor.flush()
    expect(stubs.nested_destroy).to.have.been.called

  it 'test destroy null', (test)->
    nested = model.nested
    stubs.create 'nested_destroy', nested, 'destroy'
    model.nested = null
    Meteor.flush()
    expect(stubs.nested_destroy).to.have.been.called