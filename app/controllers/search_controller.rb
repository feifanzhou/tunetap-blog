class SearchController < ApplicationController
  def search
    @query = params[:q]
    results = PgSearch.multisearch(@query).to_a.map { |r| r.searchable }

    text_results = results.select { |r| r.is_a? TaggedText }
    title_results = text_results.select { |r| r.content_type == 'title'}.map(&:post)
    body_results = text_results.select { |r| r.content_type == 'body'}.map(&:post)
    post_results = (title_results + body_results).uniq

    tag_results = results.select { |r| r.is_a? Tag }
    artist_results = tag_results.select { |r| r.tag_type == 'artist' }
    genre_results = tag_results.select { |r| r.tag_type == 'genre' }
    tag_results = tag_results.select { |r| r.tag_type == 'other' }

    writer_results = results.select { |r| r.is_a? Contributor }
    @grouped_results = {
      posts: post_results,
      artists: artist_results,
      genres: genre_results,
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
