# ========== Inline tagging when creating post ==========
window.TagSug or= {}
TagSug.startIndex = -1
TagSug.cursorPositions = {}
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
  TagSug.startIndex = content.length - term.length
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
saveTextCursorPosition = (event) ->
  target = event.target
  # FIXME — Timing issue where if you type too fast
  # Length updates too quickly
  # and skips numbers. Repro in Chrome
  valueLength = target.value.length
  coords = getCaretCoordinates(target, target.selectionEnd)
  TagSug.cursorPositions[valueLength + ''] = coords
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
    event.preventDefault()
    selectTagSuggestion()
  else
    saveTextCursorPosition(event)
    findTagSuggestions(event.target)
selectTagSuggestion = ->
  console.log('Select tag suggestion')
  activeField = document.activeElement
  selectedTag = $('.TagSuggestions > li.Selected')
  tagText = $(selectedTag).text()
  tagLength = tagText.length
  newText = activeField.value.slice(0, TagSug.startIndex) + tagText
  activeField.value = newText
  # FIXME — Select nearest positions if needed
  highlightStartPos = TagSug.cursorPositions[TagSug.startIndex + '']
  highlightEndPos = getCaretCoordinates(activeField, activeField.selectionEnd)
  fontSize = window.getComputedStyle(activeField).getPropertyValue('font-size')

  tagHighlight = document.createElement('span')
  tagHighlight.className = 'TagHighlight'
  tagHighlight.style.height = fontSize
  halfHeight = parseInt(tagHighlight.style.height.slice(0, -2), 10) / 2
  # FIXME — Don't used hard-coded size. Should be half of fontSize
  tagHighlight.style.top = highlightStartPos.top + halfHeight - (halfHeight / 4) + 'px'
  tagHighlight.style.left = highlightStartPos.left + 'px'
  tagHighlight.style.width = (highlightEndPos.left - highlightStartPos.left) + 'px'
  activeField.parentNode.appendChild(tagHighlight)
$('body').on('keydown', '#titleInput', handleTagFieldKeydown)
$('body').on('keyup', '#titleInput', handleTagFieldKeyup)
$('body').on('blur', '#titleInput', -> $('#titleTagSuggestions').html(''))
$('body').on('keydown', '#contentInput', handleTagFieldKeydown)
$('body').on('keyup', '#contentInput', handleTagFieldKeyup)
$('body').on('blur', '#contentInput', -> $('#contentTagSuggestions').html(''))
$('body').on('mouseover', '.TagSuggestions li', (event) ->
  $('.TagSuggestions li.Selected').removeClass('Selected')
  $(event.target).addClass('Selected')
)
# FIXME — Get clicking on selected tag to work.

$('body').on('click', '#newPostPublish', ->
  post = {

  }
)