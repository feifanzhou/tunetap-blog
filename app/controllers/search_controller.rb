class SearchController < ApplicationController
  def search
    @query = params[:q]
    results = PgSearch.multisearch(@query).to_a.map { |r| r.searchable }

    text_results = results.select { |r| r.is_a? TaggedText }
    title_results = text_results.select { |r| r.content_type == 'title'}.map(&:post)
    body_results = text_results.select { |r| r.content_type == 'body'}.map(&:post)

    tag_results = results.select { |r| r.is_a? Tag }
    artist_results = tag_results.select { |r| r.tag_type == 'artist' }
    tag_results = tag_results.select { |r| r.tag_type == 'other' }

    writer_results = results.select { |r| r.is_a? Contributor }
    @grouped_results = {
      posts: title_results + body_results,
      artists: artist_results,
      tags: tag_results,
      writers: writer_results
    }

    respond_to do |format|
      format.html
      format.naked { render partial: 'shared/search_results', formats: [:html], locals: { query: @query, results: @grouped_results } }
      format.json { render json: grouped_results }
    end
  end
end
