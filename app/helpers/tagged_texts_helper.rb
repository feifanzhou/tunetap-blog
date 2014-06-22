module TaggedTextsHelper
  include TagsHelper
  def tagged_text_to_html(tagged_text, html_tag = 'span')
    # For future reference: tag method
    # http://api.rubyonrails.org/classes/ActionView/Helpers/TagHelper.html#method-i-tag
    opener = "<#{ html_tag } class='TaggedText'>"
    body = tagged_text.content
    tagged_text.tag_ranges.each do |range|
      start_index = range.start
      end_index = start_index + range.length
      # Triple-dot range intentional
      body[start_index...end_index] = link_to_tag(range.tag)
    end
    closer = "</#{ html_tag }"
    return "#{ opener }#{ body }#{ closer }".html_safe
  end
end