class ContributorsController < ApplicationController
  include ApplicationHelper
  def index
    if is_not_contributor
      render status: :unauthorized, html: 'If you are a contributor, please <a href="/contributors/login">login</a>'.html_safe
    end
    @contributors = Contributor.all
  end

  include InvitationsHelper
  def new
    if Contributor.count >= 1 && (params[:access_code].blank? || invalid_access_code(params[:access_code]))
      render status: :forbidden, text: 'Forbidden' and return
    end
    @access_code = params[:access_code] || ''
  end

  def create
    if params[:access_code].blank? && Contributor.count >= 1
      render status: :unauthorized, text: 'Need an access code' and return
    end
    invitation = Invitation.find_by_access_code(params[:access_code])
    if invitation.blank? && Contributor.count >= 1
      render status: :unauthorized, text: 'Invalid access code' and return
    end
    c = Contributor.new(contributor_params)
    c.is_admin = invitation.blank? ? Contributor.count < 1 : invitation.should_be_admin
    c.received_invitation = invitation
    c.save
    invitation.is_accepted = true
    cookies.signed.permanent[:remember_token] = c.remember_token
    redirect_to root_path
  end

  def show
    @contributor = Contributor.find(params[:id])
    @is_logged_in = is_contributor
    should_show_all = @is_logged_in && !params[:all].blank? && params[:all] == 't'
    @posts = @contributor.posts_for_page(1, 10, should_show_all).select { |post| !post.blank? }
  end

  def login
    if is_contributor
      redirect_to root_path and return
    end
  end
  
  def enter
    c = Contributor.find_by_email(params[:contributor][:email])
    if !c.blank? && c.authenticate(params[:contributor][:password])
      cookies.signed[:remember_token] = c.remember_token
      redirect_to root_path and return
    end
    render text: 'Login error'
  end

  private
  def contributor_params
    params.require(:contributor).permit(:name, :email, :password)
  end
end
