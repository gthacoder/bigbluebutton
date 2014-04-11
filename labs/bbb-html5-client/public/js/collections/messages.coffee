define [
  'underscore',
  'backbone',
  'globals',
  'cs!models/chat'
], (_, Backbone, globals, chatModel) ->

  # TODO: this class should actually store UserModel's, for now it is only trigerring events
  MessagesCollection = Backbone.Collection.extend
    model: chatModel

    initialize: ->

    start: ->
      # TODO: this should be in `initialize`, but can't be right now because
      #       globals.connection doesn't exist yet
      # Bind to the event triggered when the client connects to the server
      if globals.connection.isConnected()
        @_registerEvents()
      else
        globals.events.on "connection:connected", =>
          @_registerEvents()

    _registerEvents: ->
      ###
      globals.events.on "connection:msg", (name, msg) =>
        globals.events.trigger("chat:msg", name, msg)

      globals.events.on "connection:all_messages", (messages) =>
        globals.events.trigger("chat:all_messages", messages)
      ###
      
      globals.events.on "connection:privateMsg-sender", (message) =>
        @add 
          timeStamp: message.header.timestamp
          name: message.header.name
          toname: message.payload.chat_message.to.name
          toId: message.payload.chat_message.to.id
          fromname: message.payload.chat_message.from.name
          fromId: message.payload.chat_message.from.id
          msg: message.payload.chat_message.message.text
        
        console.log "============="+ @toJSON()
        globals.events.trigger("chat:privateMsg-sender", message)
      
      globals.events.on "connection:privateMsg-receiver", (message) =>
        @add 
          timeStamp: message.header.timestamp
          name: message.header.name
          toname: message.payload.chat_message.to.name
          toId: message.payload.chat_message.to.id
          fromname: message.payload.chat_message.from.name
          fromId: message.payload.chat_message.from.id
          msg: message.payload.chat_message.message.text
        
        console.log "++++++++++++++++"+@toJSON()
        globals.events.trigger("chat:privateMsg-receiver", message)

  MessagesCollection
