Template.hello2.inheritsHooksFrom("basic")
Template.hello2.inheritsHelpersFrom("basic")

class B extends BaseReactive
  @schema:
    alias:
      type: String

class A extends BaseReactive
  @schema:
    first:
      type: String
    last:
      type: String
    lista:
      type: [String]
    sex:
      type: String
    alias:
      type: B
    flag:
      type: Boolean
    toggle:
      type: Boolean
  fullName: (sep) -> @first + sep + @last + ',' + @alias.alias
  notcan: -> not @first or not @last
  show: -> @flag and '==> ' + @first
  cansee: -> @first != ''
  picado: -> @toggle = not @toggle

Template.hello2.hooks
  created: ->
    this.model = new A
      first: 'miguel'
      last: 'angel'
      lista: []
      sex: 'female'
      alias: new B
        alias: 'mola'

Template.hello2.events
  'click button': (e,t)->
    t.model.lista = ['miguel']
    t.model.first = 'miguel'
    t.model.sex = 'male'

