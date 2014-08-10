# ========== Background blur ==========
# http://stackoverflow.com/a/17224287/472768
CanvasImage = (e, t) ->
  @image = t
  @element = e
  @element.width = @image.width
  @element.height = @image.height

  n = navigator.userAgent.toLowerCase().indexOf("chrome") > -1
  r = navigator.appVersion.indexOf("Mac") > -1
  n and r and (@element.width = Math.min(@element.width, 300)
  @element.height = Math.min(@element.height, 200)
  )
  @context = @element.getContext("2d")
  @context.drawImage(@image, 0, 0)

  return

CanvasImage:: = blur: (e) ->
  @context.globalAlpha = .5
  t = -e

  while t <= e
    n = -e

    while n <= e
      @context.drawImage(@element, n, t)
      n >= 0 and t >= 0 and @context.drawImage(@element, -(n - 1), -(t - 1))
      n += 2
    t += 2
  @context.globalAlpha = 1
  return

$(->
  image = undefined
  canvasImage = undefined
  canvas = undefined
  $(".BkgBlur").each ->
    canvas = this
    image = new Image
    image.onload = ->
      canvasImage = new CanvasImage(canvas, this)
      canvasImage.blur(4)

      return

    image.src = $(this).attr("src")

    return

  return
)

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
# $('body').on('focus', '#titleInput', saveTextCursorPosition)
# $('body').on('keydown', '#titleInput', handleTagFieldKeydown)
# $('body').on('keyup', '#titleInput', handleTagFieldKeyup)
# $('body').on('blur', '#titleInput', -> $('#titleTagSuggestions').html(''))
# $('body').on('focus', '#contentInput', saveTextCursorPosition)
# $('body').on('keydown', '#contentInput', handleTagFieldKeydown)
# $('body').on('keyup', '#contentInput', handleTagFieldKeyup)
# $('body').on('blur', '#contentInput', -> $('#contentTagSuggestions').html(''))
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
    original_code: $('#embedInput').val()
    image_url: $('#imageInput').val()
    download_link: $('#downloadInput').val()
    twitter_text: $('#twitterInput').val()
    tags_text: $('#tagsInput').val()
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

$('body').on('click', '#updatePost', (e) ->
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
    original_code: $('#embedInput').val()
    image_url: $('#imageInput').val()
    download_link: $('#downloadInput').val()
    twitter_text: $('#twitterInput').val()
    is_deleted: false
    tags_text: $('#tagsInput').val()
  }
  $.ajax ('/posts/' + e.target.getAttribute('data-post-id')),
    type: 'PATCH'
    data: { post: post }
    dataType: 'json'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('Error updating: ' + errorThrown)
    success: (resp) ->
      window.location = resp.post_path
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

  containerID = '#' + fieldID + 'TagPromptContainer'
  $(containerID).slideUp()
$('body').on('click', '.CreateTag', createTag)

# ========== Deleting posts ==========
$('body').on('click', '.DeletePost', (event) ->
  postID = event.target.getAttribute('data-post-id')
  $.ajax ('/posts/' + postID),
    type: 'DELETE'
    dataType: 'JSON'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('Error deleting post: ' + errorThrown)
    success: (data, textStatus, jqXHR) ->
      $(event.target).siblings('.PostContent').slideUp()
      $(event.target).siblings('.PostDeleted').slideDown()
)
$('body').on('click', '.UndoPostDelete', (event) ->
  event.preventDefault()
  postID = event.target.getAttribute('data-post-id')
  $.ajax ('/posts/' + postID),
    type: 'PATCH'
    dataType: 'JSON'
    data: {
      post: { is_deleted: false }
    }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('Error undeleting post: ' + errorThrown)
    success: (data, textStatus, jqXHR) ->
      $(event.target).parents('.Tile').children('.PostContent').slideDown()
      $(event.target).parents('.Tile').children('.PostDeleted').slideUp()
      $(event.target).parents('.Tile').children('.Faded').removeClass('Faded')
)

# ========== Voting on posts ==========
sendVote = (postID, isUpvote, isDeleted) ->
  $.ajax '/votes',
    type: 'POST'
    dataType: 'JSON'
    data: {
      post_id: postID
      is_upvote: isUpvote
      is_deleted: isDeleted
    }
    success: (resp) -> console.log(resp)

toggleVoteDisplay = (target, isDeleted) ->
  $('.VoteActive').removeClass('VoteActive')
  if isDeleted
    $(target).removeClass('VoteActive')
  else
    $(target).addClass('VoteActive')

$('body').on('click', '.PostUpvote', (e) ->
  postID = e.target.getAttribute('data-post-id')
  isDeleted = $(e.target).hasClass('VoteActive')
  sendVote(postID, true, isDeleted)
  toggleVoteDisplay(e.target, isDeleted)
)
$('body').on('click', '.PostDownvote', (e) ->
  postID = e.target.getAttribute('data-post-id')
  isDeleted = $(e.target).hasClass('VoteActive')
  sendVote(postID, false, isDeleted)
  toggleVoteDisplay(e.target, isDeleted)
)