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
  $("#calendar").fullCalendar
    dayClick: () ->
      console.log "Day has been clicked"
    events: (start, end, callback) ->
      rezervations = @Rezervations.find
        item_id: Session.get('currentItem')._id
        end: {$gt: start.getTime() }
        start: {$lt: end.getTime() }
      events = []
      rezervations.forEach (event) ->
        console.log event
        events.push
          title: event.title
          start: event.start / 1000
          end: event.end / 1000
      console.log events
      callback(events)