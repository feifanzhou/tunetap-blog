class ContributorsController < ApplicationController
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
    c.save
    redirect_to contributor_path(c)
  end

  def show
    @contributor = Contributor.find(params[:id])
  end

  private
  def contributor_params
    params.require(:contributor).permit(:name, :email, :password)
  end
end
