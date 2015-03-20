Template.testBindings.inheritsHooksFrom("sb_basic")

class A extends BaseReactive
  @schema:
    first:
      type: String
    cinema:
      type: [String]
    flag:
      type: Boolean

model = new A
  first: 'miguel'
  cinema: ['miguel']
  flag: true

Template.testBindings.hooks
  created: ->
    this.model = model

describe 'binding suite', ->
  el = null
  beforeEach ->
    el = Blaze.renderWithData(Template.testBindings, {},$('body')[0])
    Meteor.flush()
  afterEach ->
    Blaze.remove(el)

  it 'test bind', (test)->
    test.equal model.first, $("body").find("#0").val()
    $("body").find("#0").val('veronica')
    $("body").find("#0").trigger('keyup')
    test.equal model.first, 'veronica'
    model.first = 'bernardo'
    Meteor.flush()
    test.equal model.first, $("body").find("#0").val()

  it 'test select', (test)->
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