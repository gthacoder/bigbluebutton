Template.whiteboard.rendered = ->
  $(window).resize( ->
    currentSlide = getCurrentSlideDoc()
    
    pic = new Image()
    pic.onload = -> 
      originalWidth = this.width
      originalHeight = this.height
      
      boardWidth = $("#whiteboard-navbar").width()
      
      boardHeight = $("#whiteboard").height() - $("#whiteboard-navbar").height() - 10
      
      if originalWidth <= originalHeight
        adjustedWidth = boardHeight * originalWidth / originalHeight
        $('#whiteboard-paper').width(adjustedWidth)
        if boardWidth < adjustedWidth
          adjustedHeight = boardHeight * boardWidth / adjustedWidth
          adjustedWidth = boardWidth
        else
          adjustedHeight = boardHeight
        $("#whiteboard-paper").height(adjustedHeight)
      else
        adjustedHeight = boardWidth * originalHeight / originalWidth
        $('#whiteboard-paper').height(adjustedHeight)
        if boardHeight < adjustedHeight
          adjustedWidth = boardWidth * boardHeight / adjustedHeight
          adjustedHeight = boardHeight
        else
          adjustedWidth = boardWidth
        $("#whiteboard-paper").width(adjustedWidth)
      
      wpm = Template.slide.whiteboardPaperModel
      wpm.clearShapes()
      wpm.clearCursor()
      Template.slide.manuallyDisplayShapes()
      
      #wpm._updateContainerDimensions()
      
      wpm.scale(adjustedWidth, adjustedHeight)
      
      wpm.createCursor()
      
    pic.src = currentSlide?.slide?.png_uri
  );
    
Template.whiteboard.events
  'click #clearAllAnnotations': (event) ->
    Meteor.call "publishWhiteboardClearedMessage", getCurrentUserFromSession().userId
  'click #previousSlide': (event) ->
    Meteor.call "publishSwitchToPreviousSlideMessage", getInSession("meetingId")
  'click #nextSlide': (event) ->
    Meteor.call "publishSwitchToNextSlideMessage", getInSession("meetingId")

Template.whiteboard.helpers
  isCurrentSlideFirst: ->
    currentPresentationDoc = Meteor.Presentations.findOne({"meetingId" : getInSession("meetingId"), "presentation.current" : true})
    currentSlideDoc = Meteor.Slides.findOne({"meetingId" : getInSession("meetingId"), "presentationId": currentPresentationDoc?.presentation.id, "slide.current" : true})
    if currentSlideDoc?.slide.num is 1
      return true
    else
      return false
  
  isCurrentSlideLast: ->
    currentPresentationDoc = Meteor.Presentations.findOne({"meetingId" : getInSession("meetingId"), "presentation.current" : true})
    currentSlideDoc = Meteor.Slides.findOne({"meetingId" : getInSession("meetingId"), "presentationId": currentPresentationDoc?.presentation.id, "slide.current" : true})
    numSlidesAfter = Meteor.Slides.find({"meetingId" : getInSession("meetingId"), "presentationId": currentPresentationDoc?.presentation.id, "slide.num" : { $gt: currentSlideDoc?.slide.num }}).count()
    if numSlidesAfter is 0
      return true
    else
      return false
