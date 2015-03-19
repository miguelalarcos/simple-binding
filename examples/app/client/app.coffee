Template.hello2.inheritsHooksFrom("basic")
Template.hello2.inheritsHelpersFrom("basic")

Template.hello2.hooks
  created: ->
    this.model = new A
      first: 'miguel'
      last: 'angel'
      alias: new B
        alias: 'miguelmola'
      lista: []

Template.hello2.events
  'click button': (e,t)->
    t.model.lista = ['miguel']
    t.model.first = 'miguel'
    t.model.sex = 'male'

