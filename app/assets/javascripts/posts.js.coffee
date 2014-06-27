# ========== Inline tagging when creating post ==========
window.TagSug or= {}
TagSug.startIndex = -1
TagSug.cursorPositions = {}
TagSug.tags = []
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
  console.log(JSON.stringify(TagSug.cursorPositions, null, 2))
handleTagFieldKeyup = (event) ->
  promptContainerID = '#' + event.target.getAttribute('id') + 'TagPromptContainer'
  $(promptContainerID).slideUp

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
drawTagHighlight = (textField, height, startPos, endPos) ->
  tagHighlight = document.createElement('span')
  tagHighlight.className = 'TagHighlight'
  tagHighlight.style.height = height
  halfHeight = parseInt(tagHighlight.style.height.slice(0, -2), 10) / 2
  tagHighlight.style.top = startPos.top + halfHeight - (halfHeight / 4) + 'px'
  tagHighlight.style.left = startPos.left + 'px'
  tagHighlight.style.width = (endPos.left - startPos.left) + 'px'
  textField.parentNode.appendChild(tagHighlight)
selectTagSuggestion = ->
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

  drawTagHighlight(activeField, fontSize, highlightStartPos, highlightEndPos)

  tagID = parseInt($(selectedTag).data('tag-id'))
  fieldID = activeField.getAttribute('id')
  contentType = if fieldID == 'titleInput' then 'title' else if fieldID == 'contentInput' then 'body' else ''
  tagRange = {
    content_type: contentType
    tag_id: tagID
    start: TagSug.startIndex
    length: tagLength
  }
  TagSug.tags.push(tagRange)
$('body').on('focus', '#titleInput', saveTextCursorPosition)
$('body').on('keydown', '#titleInput', handleTagFieldKeydown)
$('body').on('keyup', '#titleInput', handleTagFieldKeyup)
$('body').on('blur', '#titleInput', -> $('#titleTagSuggestions').html(''))
$('body').on('focus', '#contentInput', saveTextCursorPosition)
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
    tagged_texts: [
      {
        content_type: 'title'
        content: $('#titleInput').val()
      },
      {
        content_type: 'body'
        content: $('#contentInput').val()
      }
    ]
    tag_ranges: TagSug.tags
    embed_link: $('#embedInput').val()
    download_link: $('#downloadInput').val()
    twitter_text: $('#twitterInput').val()
  }
  $.ajax '/posts',
    type: 'POST'
    data: { post: post }
    dataType: 'html'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('Error posting: ' + errorThrown)
    success: (data, textStatus, jqXHR) ->
      # InnerHTML for performance reasons
      # http://jsperf.com/jquery-append-vs-html-list-performance/2
      currentHTML = document.getElementById('posts').innerHTML
      newHTML = data + currentHTML
      document.getElementById('posts').innerHTML = newHTML
      newPostTop = $('.NewPost').first().offset().top
      $('html, body').animate({
        scrollTop: (0.75 * newPostTop)
      }, 500)
      setTimeout( (-> $('.NewPost').removeClass('NewPost')), 1500)
)

# =========== Select + create new tags ==========
# http://stackoverflow.com/a/5379408/472768
TagSug.selectedText = ''
getSelectionText = ->
  text = ''
  if window.getSelection
    text = window.getSelection().toString()
  else if document.selection && document.selection.type != "Control"
    text = document.selection.createRange().text
  return text
finishSelection = (event) ->
  if !document.activeElement || document.activeElement.tagName == 'body'
    console.log('Not in text field')
  selectedText = getSelectionText()
  containerID = '#' + event.target.getAttribute('id') + 'TagPromptContainer'
  if selectedText.length < 1
    $(containerID).slideUp()
    return
  $(containerID).slideDown()
  promptID = '#' + event.target.getAttribute('id') + 'TagPrompt'
  $(promptID).html(selectedText)
  TagSug.selectedText = selectedText
$('body').on('mouseup', '#titleInput', finishSelection)
$('body').on('mouseup', '#contentInput', finishSelection)

createTag = (event) ->
  event.preventDefault()
  fieldID = event.target.getAttribute('data-input-id')
  console.log('Event target: ' + event.target.className)
  console.log('FieldID: ' + fieldID)
  contentType = if fieldID == 'titleInput' then 'title' else if fieldID == 'contentInput' then 'body' else ''
  fieldValue = $('#' + fieldID).val()
  start = fieldValue.indexOf(TagSug.selectedText)
  length = TagSug.selectedText.length
  tagRange = {
    content_type: contentType
    text: TagSug.selectedText
    start: start
    length: length
  }
  TagSug.tags.push(tagRange)

  activeField = document.getElementById(fieldID)
  fontSize = window.getComputedStyle(activeField).getPropertyValue('font-size')
  highlightStartPos = TagSug.cursorPositions[start]
  console.log('Start: ' + start)
  console.log('Start pos: ' + JSON.stringify(highlightStartPos, null, 2))
  highlightEndPos = TagSug.cursorPositions[start + length]
  console.log('End pos: ' + JSON.stringify(highlightEndPos, null, 2))
  drawTagHighlight(activeField, fontSize, highlightStartPos, highlightEndPos)
$('body').on('click', '.CreateTag', createTag)