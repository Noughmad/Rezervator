Session.set 'currentItem', null
Session.set 'rezervationDate', null

MinutePrecision = 5

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
  
Template.itemDetail.rendered = () ->
  $("#calendar:empty").fullCalendar
    dayClick: (date, allDay) ->
      Session.set 'rezervationDate', date
      $("#rezervationDialogModal").modal()
      
      $("#startTimePicker").timepicker
        template: 'dropdown'
        showMeridian: false

      $("#endTimePicker").timepicker
        template: 'dropdown'
        showMeridian: false

      $("#endTimePicker").timepicker 'showWidget'
      
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
      
adjustHour = (increment, parent) ->
  input = $(parent).find "#dropdown-input-hour"
  value = parseInt input.val()
  newValue = value + increment
  while newValue >= 24
    newValue = newValue - 24
  while newValue < 0
    newValue = newValue + 24
  input.val newValue
  
adjustMinute = (increment, parent) ->
  input = $(parent).find "#dropdown-input-minute"
  value = parseInt input.val()
  newValue = value + increment
  while newValue >= 60
    newValue = newValue - 60
    adjustHour 1, parent
  while newValue < 0
    newValue = newValue + 60
    adjustHour -1, parent
  input.val newValue

Template.rezervationDialogModal.events =
  'click .hour-increment': (e) ->
    adjustHour 1, $(e.target).parent().parent()
    false

  'click .hour-decrement': (e) ->
    adjustHour -1, $(e.target).parent().parent()
    false
  
  'click .minute-increment': (e) ->
    adjustMinute MinutePrecision, $(e.target).parent().parent()
    false

  'click .minute-decrement': (e) ->
    adjustMinute -MinutePrecision, $(e.target).parent().parent()
    false