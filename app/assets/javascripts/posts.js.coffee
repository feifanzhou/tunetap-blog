# ========== Inline tagging when creating post ==========
findTagSuggestions = (target) -> 
  content = $(target).val()
  # Split content into words (delimited by spaces)
  # If last word is 2 characters or longer, that's the search string
  # If not, grab second to last word and combine with last character with space
  # That will be the search string
  $('#titleTagSuggestions').html('')
  $('#contentTagSuggestions').html('')
  contents = content.split(' ')
  return if contents.length < 1
  lastPiece = contents[contents.length - 1]
  return if contents.length <= 1 && lastPiece.length < 2
  term = if lastPiece.length > 1 then lastPiece else contents[contents.length - 2] + ' ' + lastPiece
  $.ajax ('/tags/search.naked?q=' + term),
    type: 'GET'
    dataType: 'html'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('Tag search error: ' + textStatus)
    success: (data, textStatus, jqXHR) ->
      if $(target).attr('id') == 'titleInput'
        $('#titleTagSuggestions').html(data)
      else
        $('#contentTagSuggestions').html(data)
selectTag = (currentlySelected, nextSelected) ->
  return if nextSelected.length == 0
  $(currentlySelected).removeClass('Selected')
  $(nextSelected).addClass('Selected')
handleTagFieldKeydown = (event) ->
  keyCode = event.keyCode
  selectedTag = $('.TagSuggestions .Selected')
  return if selectedTag.length == 0
  # Prevent cursor jumping around when navigation tag suggestions
  if keyCode == 38 || keyCode == 40
    event.preventDefault()
    return false
handleTagFieldKeyup = (event) ->
  keyCode = event.keyCode
  selectedTag = $('.TagSuggestions .Selected')
  if keyCode == 38 # Up arrow
    return if selectedTag.length == 0
    event.preventDefault()
    previous = $(selectedTag).prev()
    selectTag(selectedTag, previous)
  else if keyCode == 40 # Down arrow
    return if selectedTag.length == 0
    event.preventDefault()
    next = $(selectedTag).next()
    selectTag(selectedTag, next)
  else if keyCode == 13
    return
  else
    findTagSuggestions(event.target)
$('body').on('keydown', '#titleInput', handleTagFieldKeydown)
$('body').on('keyup', '#titleInput', handleTagFieldKeyup)
$('body').on('blur', '#titleInput', -> $('#titleTagSuggestions').html(''))
$('body').on('keydown', '#contentInput', handleTagFieldKeydown)
$('body').on('keyup', '#contentInput', handleTagFieldKeyup)
$('body').on('blur', '#contentInput', -> $('#contentTagSuggestions').html(''))

$('body').on('click', '#newPostPublish', ->
  post = {

  }
)