Meteor.startup () ->
  items = @Items.find {}
  if items.count() == 0
    laptop_id = @Items.insert
      name: 'Laptop Acer'
      count: 12
      image: '<< Tu bo slika >>'
      location: 'Omara'

    @Items.insert
      name: 'Lepilni trak'
      count: 80
      image: 'Ni slike'
      location: 'Omara'
    
    now = (new Date()).getTime()
    @Rezervations.insert
      title: "Maja Poklinek"
      item_id: laptop_id
      start: now
      end: now + 3600 * 1000