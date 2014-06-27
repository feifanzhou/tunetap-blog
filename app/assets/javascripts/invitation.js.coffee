# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('body').on('click', '#inviteLink', ->
  $.ajax '/invitations',
    type: 'POST'
    dataType: 'JSON'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('Create invitation error: ' + errorThrown)
    success: (data, textStatus, jqXHR) ->
      resultString = 'Send them this link:<br />' + data.signup_path
      document.getElementById('inviteResults').innerHTML = resultString
)