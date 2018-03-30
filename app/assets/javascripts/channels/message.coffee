App.message = App.cable.subscriptions.create "MessageChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log(data['message'])
    alert data['message']

  speak: (message) ->
    @perform 'speak', message: message
