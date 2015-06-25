class A extends sb.Model
  @schema:
    first:
      type: String
    n:
      type: sb.Integer
      optional: true
      validation: (x) -> x >= 5

class N extends sb.Model
  @schema:
    x:
      type: sb.Integer
      validation: (x) -> x >= 5

class B extends sb.Model
  @schema:
    n:
      type: N

class C extends sb.Model
  @schema:
    n:
      type: [N]

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

describe 'validation suite', ->
  it 'test simple validation', (test)->
    model =
      first: 'miguel'
      n: 5
    test.equal sb.validate(model, A.schema), true

  it 'test attr not in schema', (test) ->
    model =
      first: 'miguel'
      n: 5
      x: 8
    test.equal sb.validate(model, A.schema), false

  it 'test missing optional', (test) ->
    model =
      first: 'miguel'
    test.equal sb.validate(model, A.schema), true

  it 'test optional does not validate', (test) ->
    model =
      first: 'miguel'
      n: 4
    test.equal sb.validate(model, A.schema), false

  it 'test missing mandatory attr', (test) ->
    model =
      n: 5
    test.equal sb.validate(model, A.schema), false

  it 'test wrong type', (test) ->
    model =
      first: 5
    test.equal sb.validate(model, A.schema), false

  it 'test nested', (test) ->
    model =
      n:
        x: 5
    test.equal sb.validate(model, B.schema), true

  it 'test nested fail', (test) ->
    model =
      n:
        x: 4
    test.equal sb.validate(model, B.schema), false

  it 'test nested array', (test) ->
    model =
      n: [x: 5]
    test.equal sb.validate(model, C.schema), true

  it 'test nested fail array', (test) ->
    model =
      n: [x: 4]
    test.equal sb.validate(model, C.schema), false

  it 'test nested optional', (test) ->
    model = {}
    test.equal sb.validate(model, D.schema), true

  it 'test nested optional 2', (test) ->
    model = {n: {n:''}}
    test.equal sb.validate(model, D.schema), true

  it 'test nested optional 3', (test) ->
    model = {n: {}}
    test.equal sb.validate(model, D.schema), true