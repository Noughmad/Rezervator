Session.set 'currentItem', null

Handlebars.registerHelper 'session', (input) -> Session.get(input)

Template.main.currentItem = () -> currentItem

Template.itemList.items = () ->
  Items.find {}
  
Template.itemList.events
  'click .btn-item' : () ->
    Session.set 'currentItem', @
    
Template.itemDetail.item = () ->
  Session.get 'currentItem'
  
Template.itemDetail.rendered = () ->
  console.log @
  console.log $("#calendar")
  $("#calendar").fullCalendar {}