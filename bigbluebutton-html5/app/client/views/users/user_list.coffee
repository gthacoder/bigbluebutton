Template.usersList.helpers
  getInfoNumberOfUsers: ->
    numberUsers = BBB.getNumberOfUsers()
    if numberUsers > 8
      return "Users: #{numberUsers}"
    # do not display the label if there are just a few users

Template.usersList.events
  "click .closeUserlistIcon": (event, template) ->
    toggleUsersList()

Template.usersList.rendered = ->
  $('#users').resizable
    handles: 'e' # only east handle can be used
    minWidth: 200
    resize: (event, ui) ->
      $('#main').width($('#container').width() - $('#users').width() - 1)
    stop: (event, ui) ->
      $('#users').css('width', ($('#users').width() * 100) / $('#container').width() + '%')
      $('#main').css('width', 99.9 - (($('#users').width() * 100) / $('#container').width()) + '%')
