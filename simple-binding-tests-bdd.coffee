class A extends sb.Model
  @schema:
    a1:
      type: String
      optional: true

describe 'to BDD suite', ->
  it 'test simple empty', (test)->
    a = new A a1: ''
    test.equal a.toBDD(), {}

  it 'test simple not empty', (test)->
    a = new A a1: 'hello'
    test.equal a.toBDD(), {a1: 'hello'}