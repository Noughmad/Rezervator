Meteor.startup () ->
  items = @Items.find {}
  if items.count() == 0
    @Items.insert
      name: 'Laptop Acer'
      count: 12
      image: '<< Tu bo slika >>'
      location: 'Omara'

    @Items.insert
      name: 'Lepilni trak'
      count: 80
      image: 'Ni slike'
      location: 'Omara'
