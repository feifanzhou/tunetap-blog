class TagsController < ApplicationController
  include ApplicationHelper
  def index
    if is_not_contributor
      render status: :unauthorized, html: 'If you are a contributor, please <a href="/contributors/login">login</a>'.html_safe
    end
    @tags = Tag.all
  end

  def new
    redirect_to tags_path
  end

  def create
    t = Tag.new(tag_params)
    t.contributor = active_contributor
    t.save
    redirect_to tags_path
  end

  def show
    @tag = Tag.find(params[:id])
    @page = params[:index] ? params[:index].to_i : 1
    @page_count = (@tag.posts.count / 10.0).ceil
    @page_path_base = "/tags/#{ params[:id] }/page"
    @posts = @tag.posts_for_page(@page, 10).select { |post| !post.blank? }
  end

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

  private
  def tag_params
    params.require(:tag).permit(:name, :tag_type)
  end
end
