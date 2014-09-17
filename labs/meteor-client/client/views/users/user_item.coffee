@sendChangePresenterMessage = (oldPresenterId, newPresenterId, newPresenterName) ->
  dataForServer =
    "old_presenter_id": oldPresenterId
    "new_presenter_id": newPresenterId
    "time": getTime()
    "current_meeting_id": getInSession("meetingId")
    "new_presenter_name": newPresenterName
  Meteor.call "sendChangePresenterMessageToServer", dataForServer

Template.displayUserIcons.events
  'click .statusIcon': (event) ->
    presenterDoc = Meteor.Users.findOne({"user.presenter": true})
    unless this.user.userid is presenterDoc.userId
      sendChangePresenterMessage(presenterDoc.userId, this.user.userid, presenterDoc.meetingId, this.user.name)
  'click .raisedHandIcon': (event) ->
    Meteor.call('userLowerHand', getInSession("meetingId"), this.user.userid, getInSession("userId"))
