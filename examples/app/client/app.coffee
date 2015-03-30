Template.hello2.inheritsHooksFrom("sb_basic")
Template.C.inheritsHooksFrom("sb_basic")
Template.B.inheritsHooksFrom("sb_basic")
Template.D.inheritsHooksFrom("sb_basic")

hljs.initHighlightingOnLoad()

options = sb.reactiveArray(['miguel', 'veronica', 'bernardo'])

Template.hello.helpers
  data: ->
    new A
      first: 'miguel'
      last: 'alarcos'
      date: moment()
      lista: ['miguel']
      numbers: []
      flag: false
      sex: 'male'
      value: new D(value: 8)
      alias: [new B
                alias: 'mola'
                emails: [new C(email:'m@m.es'), new C(email:'m2@m.es')]
      ]

Template.hello2.helpers
  options: ->
    options.depend()
    options

class D extends sb.ReactiveModel
  @schema:
    value:
      type: Number

class C extends sb.ReactiveModel
  @schema:
    email:
      type: String

class B extends sb.ReactiveModel
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

class A extends sb.ReactiveModel
  @schema:
    first:
      type: String
    last:
      type: String
    date:
      type: Date
    lista:
      type: [String]
    sex:
      type: String
    value:
      type: D
    alias:
      type: [B]
    flag:
      type: Boolean
    numbers:
      type: [Number]
    firstFocus:
      type: Boolean
  days: -> @date.diff(moment(), 'days') + ' days.'
  log: (x) -> console.log x
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
    @value = new D(value:18)
  clicked: ->
    @alias[0].toggle = not @alias[0].toggle
    @lista = ['miguel']
    @first = 'miguel'
    @sex = 'male'
    @numbers.push Math.floor((Math.random() * 10) + 1)
    if 'diego' not in options
      options.push('diego')
    @alias[0].emails.set(0, new C(email:'myEmail@email.es'))

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

  eventDemo: -> """<input type='text' sb sb-events='click log, keyup log'>
  """

  fadeDemo: -> """<div sb sb-fade="alias.0.toggleFunc">game over!</div>
  """

  classDemo: -> """<div sb sb-text="fullName" sb-class="classesFunc"></div>
  """

  hoverDemo: -> """<button sb sb-hover='flag'>hover me</button>
  """

  visibleDemo: -> """<div sb sb-visible="flag"></div>
  """

  customBoolDemo: -> """{{> sbCustomCheck sb-customcheck-class="myCheck" sb-custom-bool="flag"}}
  """

  dateDemo: -> """{{> sbDateTime sb-datetime='date' format='DD-MM-YYYY HH:mm' time=true}}
  """