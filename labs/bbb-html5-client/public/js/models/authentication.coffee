define [
  'underscore',
  'backbone'
], (_, Backbone) ->

  AuthenticationModel = Backbone.Model.extend
    url: '/auth'
    defaults:
      username: null
      meetingID: null
      meetingName:null
      userID: null
      loginAccepted: false

  AuthenticationModel
