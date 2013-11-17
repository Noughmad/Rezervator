Session.set 'currentItem', null
Session.set 'rezervationDate', null

Handlebars.registerHelper 'session', (input) -> Session.get(input)

Template.main.currentItem = () -> currentItem

Template.itemList.items = () ->
  Items.find {}
  
Template.itemList.events
  'click .btn-item' : () ->
    Session.set 'currentItem', @
    
Template.itemDetail.item = () ->
  Session.get 'currentItem'
  
Template.rezervationDialogModal.rezervationData = () ->
  {
    date: Session.get 'rezervationDate'
    item: Session.get 'currentItem'
  }
  
Template.rezervationDialogModal.rendered = () ->
  $("#startTimePicker").timepicker
    showMeridian: false
  $("#startTimePicker").timepicker
    showMeridian: false
  
Template.itemDetail.rendered = () ->
  $("#calendar:empty").fullCalendar
    dayClick: (date, allDay) ->
      Session.set 'rezervationDate', date
      $("#rezervationDialogModal").modal()
    events: (start, end, callback) ->
      rezervations = @Rezervations.find
        item_id: Session.get('currentItem')._id
        end: {$gt: start.getTime() }
        start: {$lt: end.getTime() }
      events = []
      rezervations.forEach (event) ->
        events.push
          title: event.title
          start: event.start / 1000
          end: event.end / 1000
      callback(events)