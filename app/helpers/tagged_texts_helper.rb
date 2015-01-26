module TaggedTextsHelper
  include TagsHelper
  def tagged_text_to_html(tagged_text, html_tag = 'span')
    # For future reference: tag method
    # http://api.rubyonrails.org/classes/ActionView/Helpers/TagHelper.html#method-i-tag
    opener = "<#{ html_tag } class='TaggedText'>"
    body = tagged_text.content
    # Split up body into tagged bits and untagged bits
    body_pieces = []
    # previous_offset is amount chomped off by a tag range
    previous_offset = 0
    ranges = tagged_text.tag_ranges
    ranges.each do |range|
      # Save piece of string before tag
      body_pieces << body.slice!(0, range.start - previous_offset)
      # Get piece of string to be tagged
      body_pieces << body.slice!(0, range.length)
      previous_offset = range.start + range.length
    end
    # Anything after last tag
    body_pieces << body if body.length > 0
    # Replace tagged bits with links
    # First tagged bit will always start at index 1
    # Although index 0 might be nil or blank string. That's OK
    (1...body_pieces.length).step(2) do |i|
      # Use integer division to get floor
      body_pieces[i] = link_to_tag(ranges[i / 2].tag)
    end
    body = body_pieces.join('')
    body.gsub!("\n\n", '</p><p>')
    body.gsub!("\n", '<br />')
    closer = "</#{ html_tag }>"
    return "#{ opener }#{ body }#{ closer }".html_safe
  end
end