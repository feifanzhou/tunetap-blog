# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

TagEntry = React.createClass
  deleteTag: (e) ->
    arrayIndex = e.currentTarget.getAttribute('data-index')
    $.ajax ('/tags/' + e.currentTarget.getAttribute('data-tag-id')),
      type: 'DELETE'
      dataType: 'JSON'
      error: (req, status, error) -> alert(error)
      success: ((resp) ->
        @props.removeTag(parseInt(arrayIndex))).bind(this)
  render: ->
    React.DOM.tr
      children: [
        React.DOM.td
          children: @props.tag.name
        React.DOM.td
          children: @props.tag.contributor_name
        React.DOM.td
          children: @props.tag.tag_type
        React.DOM.td
          children: 
            React.DOM.a
              href: @props.tag.path_with_slug
              children: @props.tag.post_count
        React.DOM.td
          children:
            React.DOM.a
              href: '#'
              'data-tag-id': @props.tag.id
              'data-index': @props.index
              onClick: @deleteTag
              className: 'fa fa-trash-o'
      ]
NewTag = React.createClass
  getInitialState: ->
    { type: '' }
  selectTagType: (e) ->
    @setState({ type: e.currentTarget.getAttribute('data-type') })
  saveNewTag: ->
    tag = {
      name: @refs.tagName.getDOMNode().value
      tag_type: @refs.tagType.getDOMNode().value
    }
    _t = this
    $.ajax '/tags',
      type: 'POST'
      data: { tag: tag }
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        alert('Error creating tag: ' + errorThrown)
      success: (resp) ->
        _t.props.addTag(resp)
  render: ->
    React.DOM.tr
      children: [
        React.DOM.td
          children:
            React.DOM.input
              className: 'small'
              ref: 'tagName'
              type: 'text'
              id: 'tagName'
              name: 'name'
              placeholder: 'Tag text'
        React.DOM.td
          children: document.getElementById('creator').innerHTML
        React.DOM.td
          children: [
            React.DOM.ul
              className: 'button-group'
              children: [
                React.DOM.li
                  children: 
                    React.DOM.button
                      className: 'tiny button'
                      'data-type': 'artist'
                      onClick: @selectTagType
                      children: 'Artist'
                React.DOM.li
                  children: 
                    React.DOM.button
                      className: 'tiny button'
                      'data-type': 'genre'
                      onClick: @selectTagType
                      children: 'Genre'
                React.DOM.li
                  children: 
                    React.DOM.button
                      className: 'tiny button'
                      'data-type': 'other'
                      onClick: @selectTagType
                      children: 'Other'
              ]
            React.DOM.input
              type: 'hidden'
              ref: 'tagType'
              id: 'tagType'
              value: @state.type
          ]
        React.DOM.td
          children:
            React.DOM.button
              className: 'radius button tiny'
              id: 'tagSubmit'
              onClick: @saveNewTag
              children: 'Save'
      ]
TagList = React.createClass
  getInitialState: ->
    { tags: JSON.parse(document.getElementById('tags').innerHTML) }
  addTag: (tag) ->
    tags = @state.tags
    tags.push(tag)
    @setState({ tags: tags })
  removeTag: (index) ->
    tags = @state.tags
    tags.splice(index, 1)
    @setState({ tags: tags })
  render: ->
    removeTag = @removeTag
    tagList = @state.tags.map((t, index) -> TagEntry({ tag: t, index: index, removeTag: removeTag }))
    tagList.push(NewTag({ addTag: @addTag }))
    React.DOM.table
      children: [
        React.DOM.thead
          children: [
            React.DOM.tr
              children: [
                React.DOM.th
                  children: 'Tag name'
                React.DOM.th
                  children: 'Creator'
                React.DOM.th
                  children: 'Type (for search results)'
                React.DOM.th
                  children: 'Posts'
                React.DOM.th
                  children: 'Delete'
              ]
          ]
        React.DOM.tbody
          children: tagList
      ]
tagListEl = document.getElementById('tagList')
if tagListEl
  React.renderComponent(TagList(), tagListEl)
else
  console.log('No tag list element')