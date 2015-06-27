@surnamesCollection = new Mongo.Collection('Surnames')

class @A extends sb.Model
  @schema:
    a:
      type: String
      validation: (x) ->
        if Meteor.isServer
          surnamesCollection.findOne({surname: x})
        else
          sb.isValidAutocomplete('demoId')