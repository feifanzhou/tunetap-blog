module SessionsHelper
  include HeaderCookies

  def active_session
    code = cookies[:session_code] || header_cookies[:session_code]
    if code.blank?
      code = params[:session_code]
    end
    Session.find_by_session_code(code)
  end

  def is_active_session
    !active_session.blank?
  end

  def save_session_cookie(session)
    cookies.permanent[:session_code] = session.code
  end
end