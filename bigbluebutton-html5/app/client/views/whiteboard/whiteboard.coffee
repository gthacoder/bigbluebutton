# redraw the whiteboard to adapt to the resized window
@redrawWhiteboard = (callback) ->
  adjustedDimensions = scaleSlide(getInSession('slideOriginalWidth'), getInSession('slideOriginalHeight'))
  wpm = whiteboardPaperModel
  wpm.clearShapes()
  wpm.clearCursor()
  manuallyDisplayShapes()
  wpm.scale(adjustedDimensions.width, adjustedDimensions.height)
  wpm.createCursor()
  if callback
    callback()

Template.whiteboard.helpers
  presentationProgress: ->
    currentPresentation = Meteor.Presentations.findOne({'presentation.current':true})
    currentSlideNum = Meteor.Slides.findOne({'presentationId': currentPresentation?.presentation.id, 'slide.current':true})?.slide.num
    totalSlideNum = Meteor.Slides.find({'presentationId': currentPresentation?.presentation.id})?.count()
    if currentSlideNum isnt undefined
      return "#{currentSlideNum}/#{totalSlideNum}"
    else
      return ''

Template.whiteboard.events
  'click .previousSlide':(event) ->
    BBB.goToPreviousPage()

  'click .nextSlide':(event) ->
    BBB.goToNextPage()

  'click .switchSlideButton': (event) ->
    $('.tooltip').hide()

  'click .whiteboardFullscreenButton': (event, template) ->
    enterWhiteboardFullscreen()

  'click .exitFullscreenButton': (event, template) ->
    if document.exitFullscreen
      document.exitFullscreen()
    else if document.mozCancelFullScreen
      document.mozCancelFullScreen()
    else if document.webkitExitFullscreen
      document.webkitExitFullscreen()

  'click .raiseHand': (event) ->
    BBB.raiseHand(BBB.getMeetingId(), getInSession('userId'), getInSession('userId'), getInSession('authToken'))

  'click .lowerHand': (event) ->
    BBB.lowerHand(BBB.getMeetingId(), getInSession('userId'), getInSession('userId'), getInSession('authToken'))

Template.whiteboard.rendered = ->
  $('#whiteboard').resizable
    handles: 'e' # only east handle can be used
    minWidth: 50
    maxWidth: 1000
    alsoResize: "#chat"
    stop: (event, ui) ->
      $('#whiteboard').css('width', ($('#whiteboard').width() * 100) / $('#panels').width() + '%')
      $('#chat').css('width', 99 - (($('#whiteboard').width() * 100) / $('#panels').width()) + '%')
