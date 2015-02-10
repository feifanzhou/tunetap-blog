search = ->
  $.ajax ('/search.naked?q=' + $('#searchField').val()),
    type: 'GET'
    dataType: 'HTML'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('Error searching: ' + errorThrown)
    success: (data, textStatus, jqXHR) ->
      document.getElementById('searchResultsContainer').innerHTML = data

$('body').on('keyup', '#searchField', search)
$('body').on('search', '#searchField', search)

search() if $('#searchField').length > 0 && $('#searchField').val().length > 0

$('body').on('mousedown', '.button.Download', (e) ->
  postID = e.target.getAttribute('data-id')
)