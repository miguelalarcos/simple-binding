Template.A.inheritsHooksFrom("sb_basic")
Template.B.inheritsHooksFrom("sb_basic")
Template.Cow.inheritsHooksFrom("sb_basic")
Template.House.inheritsHooksFrom("sb_basic")

Template.bodyTemplate.helpers
  data: ->
    new A
      first: 'miguel'
      lista: [1,2,3]
      date: moment().toDate()
      date2: moment().toDate()
      age: new B
        value: 20
        cow: new Cow
          speak: 'muu'
          houses: [new House(tv: true)]

class House extends sb.Model
  @schema:
    tv:
      type: Boolean


class Cow extends sb.Model
  @schema:
    speak:
      type: String
    houses:
      type: [House]

class B extends sb.Model
  @schema:
    value:
      type: sb.Float # Number
    cow:
      type: Cow
  valuex2: ->
    @value*2

class A extends sb.Model
  @schema:
    first:
      type: String
    lista:
      type: [Number]
    date:
      type: Date
    date2:
      type: Date
    age:
      type: B
  formatDate: -> moment(@date).format('DD-MM-YYYY')
  listaToString: -> @lista.toString()
  isOld: -> @age.value > 18
  age17: ->
    @date = moment().toDate()
    @age = new B
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