Template.hello2.inheritsHooksFrom("sb_basic")
Template.hello2.inheritsHelpersFrom("sb_basic")

class C extends BaseReactive
  @schema:
    email:
      type: String

class B extends BaseReactive
  @schema:
    alias:
      type: String
    toggle:
      type: Boolean
    emails:
      type: [C]
  aliasFunc: -> 'the alias is ' + @alias
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
    numbers:
      type: [Number]
    firstFocus:
      type: Boolean
  txtFirstFocus: -> (@firstFocus and 'focus in') or ''
  classesFunc: -> if @flag then 'myClass' else ''
  fullName: -> @first + ' ' + @last + ', alias: ' + @alias[0].alias
  notCan: -> not @first or not @last
  show: -> (@flag and '==> ' + @first) or ''
  canSee: -> @first != ''
  sum: ->
    ret = 0
    for x in @numbers
      ret += x
    ret
  pop: ->
    @numbers.pop()
  clicked: ->
    @alias[0].toggle = not @alias[0].toggle
    @lista = ['miguel']
    @first = 'miguel'
    @sex = 'male'
    @numbers.push Math.floor((Math.random() * 10) + 1)

Template.hello2.hooks
  created: ->
    this.model = new A
      first: 'miguel'
      last: 'alarcos'
      lista: ['miguel']
      numbers: []
      sex: 'male'
      alias: [new B
        alias: 'mola'
        emails: [new C(email:'m@m.es'), new C(email: 'm2@m.es')]
      ]
