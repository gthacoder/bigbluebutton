define [
  'jquery',
  'underscore',
  'backbone',
  'globals',
  'cs!models/chat',
  'text!templates/session_chat.html',
  'text!templates/chat_user_list_item.html',
  'text!templates/chat_active_list.html',
  'text!templates/chat_message.html',
  'text!templates/private_chat_message.html',
  'text!templates/chat_private_tab.html',
  'text!templates/chat_private_box.html',
  'text!templates/chat_private_input_wrapper.html',
  'i18n!nls/messagestring'
], ($, _, Backbone, globals,ChatModel,sessionChatTemplate, chatUserListItem,chatActiveList,
  chatMessageTemplate, privateChatMessage, privateChatTab, privateChatBox,privateChatInputWrapper,messagestring) ->

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
      "keyup .keysupActivate" : "_privateInputKeyPressed"
      "mouseenter .chat-private-btn, mouseleave .chat-private-btn" : "_toggleDeleteSymbol"
      "click #faIcon" : "_terminatePrivateChat"


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
      data =
        General:messagestring.General
        Chat:messagestring.Chat
        Options:messagestring.Options
        Post: messagestring.Post,
        publicPlaceholder: messagestring.publicPlaceholder
      compiledTemplate = _.template(sessionChatTemplate,data)
      @$el.html compiledTemplate


    # Registers listeners for events in the application socket.
    _registerEvents: ->

      globals.events.on "chat:msg", (name, msg) =>
        @_addChatMessage(name, msg)
        @_scrollToBottom()

      globals.events.on "chat:privateMsg-sender", (message) =>
        fromUser = message.payload.chat_message.from.name
        messageText = message.payload.chat_message.message.text
        @_receiveSelfPrivateMessage(message)

      globals.events.on "chat:privateMsg-receiver", (message) =>
        fromUser = message.payload.chat_message.from.name
        messageText = message.payload.chat_message.message.text
        @_receivePrivateMessage(message)

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
          if globals.currentAuth.get("userID") isnt user.id
            @_addUserToChatList(user.id, user.name)
          else
            @_addUserToChatList(user.id, user.name+" (you)")
            $("#chat-user-"+ user.id).unbind("click")


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

    # terminate private chat 
    _terminatePrivateChat:(e)->
      $target = $(e.target)
      userId = $target.attr("data-userid")
      e.stopPropagation()
      $("#chat-input-message-wrapper-"+ userId).remove()
      $("#chat-private-message-"+ userId).remove()
      $("#chat-private-btn-"+ userId).remove()
      $("#chat-general-btn").click()


    # Add a private chat message to the screen and scroll the chat area to bottom
    _addPrivateChatMessage: (userinfo, message) ->
      data =
        username: userinfo.username
        message: message
        time: userinfo.time
      param =
        username: userinfo.username
        userid: userinfo.userid
        time: userinfo.time
        Private: messagestring.Private
      compiledTemplate = _.template(privateChatMessage, data)
      if $("#chat-private-message-"+userinfo.userid).length > 0        
         $("#chat-private-message-"+userinfo.userid).append compiledTemplate
      else
        privateChatTemplate = _.template(privateChatBox,param)
        $("#chat-private-box").append privateChatTemplate
        $("#chat-private-message-"+userinfo.userid).append compiledTemplate
        $("#chat-private-message-"+userinfo.userid).hide()
        $("#chat-private-btn-" + userinfo.userid).addClass("message-alert")

    #show a remove symbol when hover
    _addDeleteSymbol:(e)->
      $target = $(e.target)
      userId = $target.attr("data-userid") 
      $("#chat-private-btn-"+ userId).append('<div id="faIcon" data-userid="userId" ><i class="fa fa-times"  style="color:red;margin-right:1px"></i></div>')

    _toggleDeleteSymbol:(e)->
      $target = $(e.target)
      userId = $target.attr("data-userid") 
      $("#chat-private-btn-"+ userId + " span").toggle()

    # Scrolls the chat area to bottom to show the last messages
    _scrollToBottom: ->
      $msgBox = @$(@publicBoxID)
      $msgBox.prop({ scrollTop: $msgBox.prop("scrollHeight") })

    # A key was pressed in the input box
    _inputKeyPressed: (e) ->
      # Send message when the enter key is pressed
      @_sendMessage() if e.keyCode is 13

    # A key was pressed in the private chat input box
    _privateInputKeyPressed: (e) ->
      # Send message when the enter key is pressed
      $(".sendPrivateChatMsg").click() if e.keyCode is 13


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


    _addToActiveChatList: (userid, username) ->
      # only add the new element if it doesn't exist yet
      unless $("#chat-active-user-#{userid}").length > 0
        data =
          userid: userid
          username: username
        compiledTemplate = _.template(chatActiveList, data)
        $("#active-chat-user-list").append compiledTemplate

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

      if globals.currentAuth.get("userID")!=userid
        params =
          username: $target.attr("data-username")
          userid: userid
          Private: messagestring.Private

        # add a new tab and chat box for the private chat, only if needed
        console.log $("#chat-private-tabs div").length
        if $("#chat-private-tabs div").length<3
          unless $("#chat-private-btn-#{userid}").length > 0
            tab =_.template(privateChatTab, params)
            #$(@privateTabsIDs).prepend(tab)
            $(@privateTabsIDs).append(tab)
            chatBox = _.template(privateChatBox, params)
            $(@privateBoxID).append(chatBox)
            $("#chat-public-box").hide()
            $("#chat-input-wrapper").hide()
          @_selectPrivateChat(e)
        else
          unless $("#chat-private-btn-#{userid}").length > 0
            tab =_.template(privateChatTab, params)
            #$(@privateTabsIDs).prepend(tab)
            $(@privateTabsIDs).append(tab)
            chatBox = _.template(privateChatBox, params)
            $(@privateBoxID).append(chatBox)
            $("#chat-public-box").hide()
            $("#chat-input-wrapper").hide()
            $( ".chat-private-btn").first().remove()
            #$("#chat-private-btn-#{userid}").siblings(":last").remove()
            @_addToActiveChatList(params.userid,params.username)
          @_selectPrivateChat(e)

      else
        false
        #event.stopPropagation()
 

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
        userid: userid,
        Post: messagestring.Post,
        privateplaceholder: messagestring.privateplaceholder
      
      $("[id^='chat-input-message-wrapper-']").hide()
      #$("#chat-private-message-#{userid}").hide()
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
      $("[id^='chat-private-message']").hide()
      $("#chat-private-message-" + userid).show()
      $("#privateChatButton").removeClass("btn-warning").addClass("btn-default")
      $("#chat-user-#{userid}").removeClass("message-alert")


    # Inactivates all private chat tabs/buttons
    _inactivatePrivateChats: ->
      $(".chat-private-btn").removeClass("active")


    # Inactivates the public chat tab/button
    _inactivatePublicChat: ->
      $("#chat-general-btn").removeClass("active")
      $("#chat-public-box").hide()


    # Adds a default welcome message to the chat
    _addWelcomeMessage: ->
      msg = "You are now connected to the meeting '#{globals.currentAuth.get('meetingID')}'"
      @_addChatMessage("System", msg)

    # Receive Private Chat Message
    _receivePrivateMessage:(message)->
      console.log message
      fromUser = message.payload.chat_message.from.name
      fromUserId = message.payload.chat_message.from.id
      fromTimeStamp = new Date(message.header.timestamp)
      fromTime = fromTimeStamp.getHours() + ":" + fromTimeStamp.getMinutes()
      params =
        username: fromUser
        userid: fromUserId
        time: fromTime
      messageText = message.payload.chat_message.message.text
      if $("#chat-private-btn-#{fromUserId}").length > 0
        @_addPrivateChatMessage(params,messageText)
      else
        $("#privateChatButton").removeClass("btn-default").addClass("btn-warning")
        $("#chat-user-#{fromUserId}").addClass("message-alert")
        @_addPrivateChatMessage(params,messageText)

    _receiveSelfPrivateMessage:(message)->
      fromUser = message.payload.chat_message.from.name
      Id = message.payload.chat_message.to.id
      timeStampDate = new Date(message.header.timestamp)
      timeReveive = timeStampDate.getHours() + ":" + timeStampDate.getMinutes()
      params =
        username: fromUser
        userid: Id
        time: timeReveive
      messageText = message.payload.chat_message.message.text
      unless $("#chat-private-btn-#{Id}").length >0
        tab =_.template(privateChatTab, params)
        $(@privateTabsIDs).prepend(tab)
      @_addPrivateChatMessage(params,messageText)

  SessionChatView
