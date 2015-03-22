Template.hello2.inheritsHooksFrom("sb_basic")
Template.hello2.inheritsHelpersFrom("sb_basic")

hljs.initHighlightingOnLoad()

options = reactiveArray(['miguel', 'veronica', 'bernardo'])

Template.hello2.helpers
  options: ->
    options.depend()
    options

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
  listaToString: -> '[' + @lista.toString() + ']'
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
    if 'diego' not in options
      options.push('diego')

Template.hello2.hooks
  created: ->
    this.model = new A
      first: 'miguel'
      last: 'alarcos'
      lista: ['miguel']
      numbers: []
      flag: false
      sex: 'male'
      alias: [new B
        alias: 'mola'
        emails: [new C(email:'m@m.es'), new C(email: 'm2@m.es')]
      ]

Template.hello2.helpers
  bindDemo: -> """<input type="text" sb sb-bind="first" sb-focus="firstFocus">
     <span sb sb-text="first"></span>
  """

  checkDemo: -> """Miguel at the cinema?<input type="checkbox" sb value="miguel" sb-check="lista">
  """

  boolDemo: -> """Boolean: <input type="checkbox" sb sb-bool="flag">
  """

  radioDemo: -> """<input sb type="radio" name="sex" value="male" sb-radio="sex">Male
    <br>
    <input sb type="radio" name="sex" value="female" sb-radio="sex">Female
  """

  selectDemo: -> """<select sb sb-select="lista" multiple="multiple">
        {{#each options}}
            <option>{{this}}</option>
        {{/each}}
    </select>
    <br>
    Select first name:
    <select sb sb-select="first">
        {{#each options}}
            <option>{{this}}</option>
        {{/each}}
    </select>
  """

  disabledDemo: -> """<button sb sb-disabled="notCan">click</button>
  """

  focusDemo: -> """<input type="text" sb sb-focus="firstFocus">
  <span sb sb-text="txtFirstFocus"></span>
  """

  clickDemo: -> """<button sb sb-click="clicked">click</button>
  """

  fadeDemo: -> """<div sb sb-fade="alias.0.toggleFunc">game over!</div>
  """

  classDemo: -> """<div sb sb-text="fullName" sb-class="classesFunc"></div>
  """

  hoverDemo: -> """<button sb sb-hover='flag'>hover me</button>
  """