class InvitationsController < ApplicationController
  def new
    redirect_to contributors_path
  end

  include ApplicationHelper
  def create
    render status: :unauthorized and return if is_not_contributor
    @contributor = Contributor.find_by_remember_token(cookies.signed[:remember_token])
    invitation = @contributor.generate_invitation
    signup_path = "#{ ENV['ROOT_URL'] }/contributors/new?access_code=#{ invitation.access_code }"
    respond_to do |format|
      format.html { render html: "<a href='#{ signup_path }'>Signup link</a>" }
      format.json { render json: { signup_path: signup_path } }
    end
  end
end
