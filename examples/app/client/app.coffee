Template.hello2.inheritsHooksFrom("basic")
Template.hello2.inheritsHelpersFrom("basic")

class B extends BaseReactive
  @schema:
    alias:
      type: String
    toggle:
      type: Boolean
  notCan: -> @alias == 'miguel'

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
  fullName: (sep) -> @first + sep + @last + ',' + @alias.alias
  notCan: -> not @first or not @last
  show: -> @flag and '==> ' + @first
  canSee: -> @first != ''
  picado: ->
    @alias.toggle = not @alias.toggle
    @lista = ['miguel']
    @first = 'miguel'
    @sex = 'male'

Template.hello2.hooks
  created: ->
    this.model = new A
      first: 'miguel'
      last: 'angel'
      lista: []
      sex: 'female'
      alias: new B
        alias: 'mola'


