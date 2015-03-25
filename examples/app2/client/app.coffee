Template.A.inheritsHooksFrom("sb_basic")
Template.B.inheritsHooksFrom("sb_basic")
Template.Cow.inheritsHooksFrom("sb_basic")
Template.House.inheritsHooksFrom("sb_basic")

Template.bodyTemplate.helpers
  data: ->
    new A
      first: 'miguel'
      lista: [1,2,3]
      age: new B
        value: 20
        cow: new Cow
          speak: 'muu'
          houses: [new House(tv: true)]

class House extends ReactiveModel
  @schema:
    tv:
      type: Boolean


class Cow extends ReactiveModel
  @schema:
    speak:
      type: String
    houses:
      type: [House]

class B extends ReactiveModel
  @schema:
    value:
      type: Number
    cow:
      type: Cow

class A extends ReactiveModel
  @schema:
    first:
      type: String
    lista:
      type: [Number]
    age:
      type: B
  listaToString: -> @lista.toString()
  isOld: -> @age.value > 18
  age17: -> @age = new B
    value: 17
    cow: new Cow
      speak: 'muu!!!'
      houses: [new House(tv:false)]
  push: -> @age.cow.houses.push(new House(tv: true))
  pop: ->  @age.cow.houses.pop()
  splice111: -> @age.cow.houses.splice(1,1,new House(tv: true))
  set0: -> @age.cow.houses.set(0, new House(tv: true))
  pushLista: -> @lista.push(4)

Template.Cow.helpers
  echo: (x)-> console.log x