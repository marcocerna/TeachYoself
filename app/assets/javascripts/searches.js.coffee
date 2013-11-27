# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Put all functions in here for organized testing
window.App = {};

_.extend App,
  youtubeSearch: (event) ->
    event.preventDefault()

    # Grab info for ajax call
    $key = 'AIzaSyCVCYIWB54SIT_eVVAAO4WB_8432gXfNC4'
    $query = $('#search-bar').val()

    # Ajax call
    $.get("https://www.googleapis.com/youtube/v3/search?key=" + $key + "&q=" + $query + "+tutorial&part=snippet").done App.appendData

  appendData: (data) ->
    console.log data

    # Grab divs
    $singleResults = $('#videos-solo > ul')
    $multiResults = $('#videos-multi > ul')
    $playlistResults = $('#videos-playlist > ul')

    # Loop through each and append the template
    _.each data.items, (result) ->
      info = result.snippet

      # Figure out how to refine these conditions
      if info.title.search(" 1") != -1
        $multiResults.append(JST["templates/result"](result: result))
      else if (info.title.search("laylist") != -1) || (info.description.search("laylist") != -1)
        $playlistResults.append(JST["templates/result"](result: result))
      else
        $singleResults.append(JST["templates/result"](result: result))


$ ->

  $(document).keypress (e) ->
    $('#search-button').click()  if e.which is 13


  $('#search-button').on 'click', App.youtubeSearch

  # $('body').on 'hover', '', ->
  #   $('#search-bar').animate
  #     width: "200px"
  #   , 'slow'

  $(".navbar-fixed-top").hover (->
    $('#search-bar').stop(true, false).animate width: "500px"
  ), ->
    $('#search-bar').stop(true, false).animate width: "500px"

  $('.draggable').draggable()

#######################################


  # $('#videos-solo').isotope
  #   # options
  #   itemSelector : '.videoDiv'
  #   layoutMode : 'fitRows'



#######################################


  $('body').on 'click', "a[href^=\"https://www.youtube.com\"]", (e) ->

    e.preventDefault()

    # Store the query string variables and values
    # Uses "jQuery Query Parser" plugin, to allow for various URL formats (could have extra parameters)
    queryString = $(this).attr("href").slice($(this).attr("href").indexOf("?") + 1)
    queryVars = $.parseQuery(queryString)

    # if GET variable "v" exists. This is the Youtube Video ID
    if "v" of queryVars

      # Prevent opening of external page
      e.preventDefault()

      # Variables for iFrame code. Width and height from data attributes, else use default.
      vidWidth = 1200 # default
      vidHeight = 780 # default
      vidWidth = parseInt($(this).attr("data-width"))  if $(this).attr("data-width")
      vidHeight = parseInt($(this).attr("data-height"))  if $(this).attr("data-height")
      iFrameCode = "<iframe width=\"" + vidWidth + "\" height=\"" + vidHeight + "\" scrolling=\"no\" allowtransparency=\"true\" allowfullscreen=\"true\" src=\"http://www.youtube.com/embed/" + queryVars["v"] + "?rel=0&wmode=transparent&showinfo=0\" frameborder=\"0\"></iframe>"

      # Replace Modal HTML with iFrame Embed
      $("#mediaModal .modal-body").html iFrameCode

      # Set new width of modal window, based on dynamic video content
      $("#mediaModal").on "show.bs.modal", ->

        # Add video width to left and right padding, to get new width of modal window
        modalBody = $(this).find(".modal-body")
        modalDialog = $(this).find(".modal-dialog")
        newModalWidth = vidWidth + parseInt(modalBody.css("padding-left")) + parseInt(modalBody.css("padding-right"))
        newModalWidth += parseInt(modalDialog.css("padding-left")) + parseInt(modalDialog.css("padding-right"))
        newModalWidth += "px"

        # Set width of modal (Bootstrap 3.0)
        $(this).find(".modal-dialog").css "width", newModalWidth


      # Open Modal
      $("#mediaModal").modal()


  # Clear modal contents on close.
  # There was mention of videos that kept playing in the background.
  $("#mediaModal").on "hidden.bs.modal", ->
    $("#mediaModal .modal-body").html ""


# Type here!
find = (name, options) ->
  return true  if @check(name, options)
  @add name, "var"
  false