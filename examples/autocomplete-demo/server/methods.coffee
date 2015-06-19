Meteor.methods
  'data': (query) -> surnamesCollection.find({surname: {$regex: '^.*'+query+'.*$'}})