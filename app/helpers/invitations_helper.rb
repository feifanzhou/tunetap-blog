module InvitationsHelper
  def invalid_access_code(code)
    i = Invitation.find_by_access_code(code)
    return i.blank? || !i.is_active?
  end
end
