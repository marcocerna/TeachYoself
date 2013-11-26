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

    # search =
    #   search:
    #     key: $key,
    #     filter: $query
    #     part: 'snippet'

    # Ajax call (don't really need hash above)
    $.get("https://www.googleapis.com/youtube/v3/search?key=" + $key + "&q=" + $query + "+tutorial&part=snippet").done (data) ->
      console.log data

      # Grab divs
      $singleResults = $('#videos-solo')
      $multiResults = $('#videos-multi')
      $playlistResults = $('#videos-playlist')

      # Loop through each and append the template
      _.each data.items, (result) ->
        info = result.snippet

        # Figure out how to refine these conditions
        if info.title.search(" 1") != -1
          $multiResults.append(JST["templates/result"](info: info))
        else if (info.title.search("laylist") != -1) || (info.description.search("laylist") != -1)
          $playlistResults.append(JST["templates/result"](info: info))
        else
          $singleResults.append(JST["templates/result"](info: info))

$ ->
  $('#search-button').on 'click', App.youtubeSearch