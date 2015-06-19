if surnamesCollection.find({}).count() == 0
  for x in ['Dawkins', 'Dennet', 'Darwind']
    surnamesCollection.insert({surname: x})

Meteor.publish 'Surnames', ->
  surnamesCollection.find({})