class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper
  before_filter :set_or_update_session
  def set_or_update_session
    sesh = active_session
    if sesh.blank?
      p '========= Sesh is blank'
      save_session_cookie(Session.create(ip_address: request.remote_ip, last_active: DateTime.now))
    else
      sesh.last_active = DateTime.now
      sesh.save
    end
  end
end
