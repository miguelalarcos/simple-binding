Template.hello2.inheritsHooksFrom("basic")

class B extends BaseReactive
  @schema:
    alias:
      type: String
    toggle:
      type: Boolean
  notCan: -> @alias == 'miguel'
  toggleFunc: -> @toggle

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
      type: [B]
    flag:
      type: Boolean
  fullName: -> @first + ' ' + @last + ', ' + @alias[0].alias
  notCan: -> not @first or not @last
  show: -> (@flag and '==> ' + @first) or ''
  canSee: -> @first != ''
  picado: ->
    @alias[0].toggle = not @alias[0].toggle
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
      alias: [new B
        alias: 'mola'
      ]


