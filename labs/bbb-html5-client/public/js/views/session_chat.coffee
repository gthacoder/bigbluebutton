define [
  'jquery',
  'underscore',
  'backbone',
  'globals',
  'cs!models/chat',
  'text!templates/session_chat.html',
  'text!templates/chat_user_list_item.html',
  'text!templates/chat_message.html',
  'text!templates/chat_private_tab.html',
  'text!templates/chat_private_box.html',
  'text!templates/chat_private_input_wrapper.html'
], ($, _, Backbone, globals,ChatModel,sessionChatTemplate, chatUserListItem,
  chatMessageTemplate, privateChatTab, privateChatBox,privateChatInputWrapper) ->

  # The chat panel in a session
  # The contents are rendered by SessionView, this class is Used to
  # manage the events in the chat.
  SessionChatView = Backbone.View.extend
    model: new ChatModel()

    events:
      "click button#chat-send-btn": "_sendMessage"
      "keyup #chat-input-box": "_inputKeyPressed"
      "click .chat-user-list-item":"_startPrivateChat"
      "click #chat-general-btn":"_selectPublicChat"
      "click .chat-private-btn":"_selectPrivateChat"
      "click .sendPrivateChatMsg": "_sendPrivateMessage"


    initialize: ->
      # save a few IDs for easier access
      @inputBoxID = "#chat-input-box"
      @publicBoxID = "#chat-public-box"
      @userListID = "#chat-user-list"
      @privateTabsIDs = "#chat-private-tabs"
      @messageBoxesContainerID = "#chat-messages"
      @privateBoxID = "#chat-private-box"
      @model.start()

      # Bind to the event triggered when the client connects to the server
      if globals.connection.isConnected()
        @_registerEvents()
        @_addWelcomeMessage()

      else
        globals.events.on "connection:connected", =>
          @_registerEvents()
          @_addWelcomeMessage()

    render: ->
      compiledTemplate = _.template(sessionChatTemplate)
      @$el.html compiledTemplate


    # Registers listeners for events in the application socket.
    _registerEvents: ->

      globals.events.on "chat:msg", (name, msg) =>
        @_addChatMessage(name, msg)
        @_scrollToBottom()

      #Todo: display the private chat message to user

      globals.events.on "chat:privateMsg", (message) =>
        fromUser = message.payload.chat_message.from.name
        messageText = message.payload.chat_message.message.text
        console.log message
        console.log JSON.stringify(message)
        @_receivePrivateMessage(message)
        window.alert(fromUser + "   " + messageText)

      globals.events.on "chat:all_messages", (messages) =>
        unless messages == null
          for msgBlock in messages
            @_addChatMessage(msgBlock.username, msgBlock.message)
          @_scrollToBottom()

      globals.events.on "users:user_leave", (userid,username) =>
        @_removeUserFromChatList(userid, username)

      globals.events.on "users:user_join", (userid, username) =>
        @_addUserToChatList(userid, username)

      globals.events.on "users:load_users", (users) =>
        @$(@userListID).empty()
        for user in users
          @_addUserToChatList(user.id, user.name)

      # TODO: for now these messages are only being shown in the chat, maybe
      #       they should have their own view and do more stuff
      #       (e.g. disable the interface when disconnected)
      globals.events.on "connection:connected", =>
        @_addChatMessage("system", "Connected to the server.")
      globals.events.on "connection:disconnected", =>
        @_addChatMessage("system", "Disconnected form the server.")
      globals.events.on "connection:reconnect", =>
        @_addChatMessage("system", "Reconnected!")
      globals.events.on "connection:reconnecting", =>
        @_addChatMessage("system", "Reconnecting...")
      globals.events.on "connection:reconnect_failed", =>
        @_addChatMessage("system", "Reconnect failed!")

    # Add a message to the screen and scroll the chat area to bottom
    _addChatMessage: (username, message) ->
      data =
        username: username
        message: message
      compiledTemplate = _.template(chatMessageTemplate, data)
      @$(@publicBoxID).append compiledTemplate

    # Add a private chat message to the screen and scroll the chat area to bottom
    _addPrivateChatMessage: (userinfo, message) ->
      data =
        username: userinfo.username
        message: message
      param =
        username: userinfo.username
        userid: userinfo.userid
      compiledTemplate = _.template(chatMessageTemplate, data)
      if $("#chat-private-message-"+userinfo.userid).length > 0        
         $("#chat-private-message-"+userinfo.userid).append compiledTemplate
      else
        privateChatTemplate = _.template(privateChatBox,param)
        $("#chat-private-box").append privateChatTemplate
        $("#chat-private-message-"+userinfo.userid).append compiledTemplate
        $("#chat-private-message-"+userinfo.userid).hide()
        $("#chat-private-btn-" + userinfo.userid).addClass("message-alert")

    # Scrolls the chat area to bottom to show the last messages
    _scrollToBottom: ->
      $msgBox = @$(@publicBoxID)
      $msgBox.prop({ scrollTop: $msgBox.prop("scrollHeight") })

    # A key was pressed in the input box
    _inputKeyPressed: (e) ->
      # Send message when the enter key is pressed
      @_sendMessage() if e.keyCode is 13

    # Send a chat message
    _sendMessage: ->
      $chatInput = @$(@inputBoxID)
      msg = $chatInput.val()
      if msg? and msg.trim() isnt ""
        globals.connection.emitMsg msg
        $chatInput.val("")
      $chatInput.focus()

    # Send a private chat message
    _sendPrivateMessage: (e)->     
      $target = $(e.target)
      toUserId = $target.attr("data-userid")
      toUsername = $target.attr("data-username")
      privateMsg = $("#private-chat-input-box-" + toUserId).val()
      console.log privateMsg
      data =
        username: "You"
        message: privateMsg
      
      privateChatMessageJson =
        payload:
          chat_message:
            to:
              id: toUserId
              name: toUsername

            message:
              text: privateMsg
              lang: "en_US"

            font:
              color: 16711680
              size: 14
              font_type: "Arial"

      if privateMsg? and privateMsg.trim() isnt ""
        globals.connection.emitPrivateMsg privateChatMessageJson
      $("#private-chat-input-box-"+toUserId).val("")
      $("#private-chat-input-box-"+toUserId).focus()
      compiledTemplate = _.template(chatMessageTemplate, data)
      $("#chat-private-message-"+toUserId).append compiledTemplate


    # Adds a user to the list of users in the chat, used to start private chats
    # @param userid [string] the ID of the user
    # @param userid [string] the name of the user
    _addUserToChatList: (userid, username) ->
      # only add the new element if it doesn't exist yet
      unless $("#chat-user-#{userid}").length > 0
        data =
          userid: userid
          username: username
        compiledTemplate = _.template(chatUserListItem, data)
        @$(@userListID).append compiledTemplate

    # Removes a user from the list of users in the chat
    # @param userid [string] the ID of the user
    # @param userid [string] the name of the user
    _removeUserFromChatList: (userid, username) ->
      $("#chat-user-#{userid}").remove()

    # When a user clicks to start a private chat with a user
    # @param e [event] the click event that generated this call
    _startPrivateChat: (e) ->
      $target = $(e.target)
      userid = $target.attr("data-userid")
      params =
        username: $target.attr("data-username")
        userid: userid

      # add a new tab and chat box for the private chat, only if needed
      unless $("#chat-private-btn-#{userid}").length > 0
        tab =_.template(privateChatTab, params)
        $(@privateTabsIDs).prepend(tab)
        chatBox = _.template(privateChatBox, params)
        $(@privateBoxID).append(chatBox)
        $("#chat-public-box").hide()
        $("#chat-input-wrapper").hide()
      @_selectPrivateChat(e)

    # Selects the private chat
    _selectPublicChat: ->
      # set all private tabs and chat boxes as inactive
      @_inactivatePrivateChats()

      # set the public chat button and box as active
      $("#chat-general-btn").addClass("active")
      $(@publicBoxID).addClass("active").show()
      $("#chat-input-wrapper").show()
      $("#chat-private-box").hide()
      $("[id^='chat-input-message-wrapper-']").hide()

      # tell the parent element that the public chat is active
      @$el.addClass('public-chat-on')
      @$el.removeClass('private-chat-on')

    # Selects a private chat
    # @param e [event] the click event that generated this call
    _selectPrivateChat: (e) ->
      $target = $(e.target)
      userid = $target.attr("data-userid")
      params =
        username: $target.attr("data-username")
        userid: userid

      ### set all other tabs and chat boxes as inactive
      $("[id^='chat-private-message']").hide()
      $("[id^='chat-input-message-wrapper-']").hide()
      $("#chat-private-message-#{userid}").show()
      $("#chat-input-message-wrapper-#{userid}").show()
      $("#chat-input-wrapper").hide()
      $("#chat-private-box").show()
      $("[id^='chat-private-btn-']").removeClass("active")
      $("#chat-private-btn-"+userid).removeClass("message-alert")
      $("[id^='chat-private-']").removeClass("active")
      ###
      $("[id^='chat-private-message']").hide()
      $("[id^='chat-input-message-wrapper-']").hide()
      $("#chat-private-message-#{userid}").hide()
      $("#chat-input-message-wrapper-#{userid}").show();
      $("#chat-input-wrapper").hide()
      $("#chat-private-box").show()
      $("[id^='chat-private-btn-']").removeClass("active")
      $("#chat-private-btn-"+userid).removeClass("message-alert")
      $("[id^='chat-private-']").removeClass("active")
      if ($("#chat-input-message-wrapper-#{userid}").length <= 0  )
        $("#chat").append(_.template(privateChatInputWrapper,params))
      @_inactivatePublicChat()

      # set the current private chat tab and box as active and public as inactive
      $("#chat-private-btn-#{userid}").addClass("active")
      $("#chat-private-#{userid}").addClass("active")
      $(@publicBoxID).removeClass("active")

      # tell the parent element that the private chat is active
      @$el.removeClass('public-chat-on')
      @$el.addClass('private-chat-on')
      $("#chat-private-message-"+userid).show()

    # Inactivates all private chat tabs/buttons
    _inactivatePrivateChats: ->
      $(".chat-private-btn").removeClass("active")


    # Inactivates the public chat tab/button
    _inactivatePublicChat: ->
      $("#chat-general-btn").removeClass("active")
      $("#chat-public-box").hide()
      console.log "_inactivatePublicChat"

    # Adds a default welcome message to the chat
    _addWelcomeMessage: ->
      msg = "You are now connected to the meeting '#{globals.currentAuth.get('meetingID')}'"
      @_addChatMessage("System", msg)

    # Receive Private Chat Message
    _receivePrivateMessage:(message)->
      fromUser = message.payload.chat_message.from.name
      fromUserId = message.payload.chat_message.from.id
      params =
        username: fromUser
        userid: fromUserId
      messageText = message.payload.chat_message.message.text
      unless $("#chat-private-btn-#{fromUserId}").length >0
        tab =_.template(privateChatTab, params)
        $(@privateTabsIDs).prepend(tab)
      @_addPrivateChatMessage(params,messageText)



      #else if($("chat-private-message-#{fromUserId}").length < 0)


  SessionChatView
