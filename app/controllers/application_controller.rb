class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper
  before_filter :set_or_update_session
  def set_or_update_session
    ip = request.remote_ip
    p "Remote IP address is #{ ip }"
    block_list = %w(50.112.95.211 54.251.34.67 54.248.250.232 50.31.164.139 184.73.237.85 54.247.188.179)
    return if block_list.include? ip
    p "Remote IP address #{ ip } is not on block list"
    @active_session = active_session
    if @active_session.blank?
      save_session_cookie(Session.create(ip_address: ip, last_active: DateTime.now))
    else
      @active_session.last_active = DateTime.now
      @active_session.save
    end
  end
end
