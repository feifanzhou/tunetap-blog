class TagsController < ApplicationController
  def search
    query = params[:q]
    if query.blank?
      render html: ''.html_safe and return
    end
    @tags = Tag.match_with(query)
    respond_to do |format|
      # format.html
      format.naked { render partial: 'shared/tag_suggestions', formats: [:html], locals: { tags: @tags } }
    end
  end
end
