class A extends sb.Model
  @schema:
    a1:
      type: String
      optional: true

class E extends sb.Model
  @schema:
    n:
      type: sb.Integer
      optional: true

class D extends sb.Model
  @schema:
    n:
      type: E
      optional: true
    n2:
      type: [E]
      optional: true

describe 'to BDD suite', ->
  it 'test simple empty', (test)->
    a = new A a1: ''
    test.equal a.toBDD(), {}

  it 'test simple not empty', (test)->
    a = new A a1: 'hello'
    test.equal a.toBDD(), {a1: 'hello'}

  it 'test nested simple', (test) ->
    x = new D
      n: new E(n:8)
    test.equal x.toBDD(), {n: {n:8}}

  it 'test nested empty', (test) ->
    x = new D({})
    test.equal x.toBDD(), {}

  it 'test nested empty 2', (test) ->
    x = new D
      n: new E(n: '')
      n2: []
    test.equal x.toBDD(), {}

describe 'load BDD suite', ->
  it 'test simple load', (test)->
    x = new D({})
    test.equal x.n2, []
    test.equal x.n.n, ''

  it 'test load with data', (test) ->
    x = new D
      n: new E(n: '')
      n2: []
    test.equal x.n.n, ''
    test.equal x.n2, []