# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  access_code     :string(255)
#  recipient_id    :integer
#  inviter_id      :integer
#  created_at      :datetime
#  updated_at      :datetime
#  should_be_admin :boolean
#

describe 'Invitation' do
  let(:invitation) { FactoryGirl.create :invitation }
  subject{ invitation }

  it { should be_valid }
  it { should respond_to :access_code }
  it { should respond_to :recipient_id }
  it { should respond_to :inviter_id }

  it 'should be active' do
    expect(invitation.is_active?).to be true
  end

  it 'will not be active if too old' do
    invitation.created_at = DateTime.now() - 2
    invitation.save
    expect(invitation.is_active?).to be false
  end
end
