Template.displayUserIcons.events
  'click .muteIcon': (event) ->
    toggleMic @

  'click .raisedHandIcon': (event) ->
    # the function to call 'userLowerHand'
    # the meeting id
    # the _id of the person whose land is to be lowered
    # the userId of the person who is lowering the hand
    console.log "lower hand- client click handler"
    Meteor.call('userLowerHand', getInSession("meetingId"), @userId, getInSession("userId"), getInSession("authToken"))

  'click .userRoleIcon': (event) ->
    if $(this).hasClass('glyphicon-picture') is false
      Meteor.call 'assignPresenter', getInSession('meetingId'), @userId, getInSession('userId'), getInSession('authToken')
