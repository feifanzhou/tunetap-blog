require 'rails_helper'

describe 'Filling in a new post' do
  before :each do
    author = FactoryGirl.create :contributor
    tag1 = Tag.new(name: 'tag1', tag_type: 'artist')
    tag1.contributor = author
    tag1.save
    tag2 = Tag.new(name: 'tag2', tag_type: 'artist')
    tag2.contributor = author
    tag2.save
    tag3 = Tag.new(name: 'tag3', tag_type: 'artist')
    tag3.contributor = author
    tag3.save
    visit '/contributors/login'

    within '#new_contributor' do
      fill_in 'contributor_email', with: 'mike@tunetap.com'
      fill_in 'contributor_password', with: 'loginpass'
    end
    click_button 'Login'
  end

  def expect_page_to_not_have_tag_suggestions
    expect(page).to_not have_content('tag1')
    expect(page).to_not have_content('tag2')
    expect(page).to_not have_content('tag3')
  end
  def expect_page_to_have_tag_suggestions
    expect(page).to have_content('tag1')
    expect(page).to have_content('tag2')
    expect(page).to have_content('tag3')
  end

  it 'has the right fields' do
    expect(page).to have_selector '#titleInput'
  end
  it 'does not show any tags initially' do
    expect_page_to_not_have_tag_suggestions
  end

  it 'does not show tags when title input is too short', js: true do
    fill_in 'titleInput', with: 't'
    expect_page_to_not_have_tag_suggestions
  end
  it 'does not show tags when content input is too short', js: true do
    fill_in 'contentInput', with: 't'
    expect_page_to_not_have_tag_suggestions
  end
  it 'does not show tags when title input does not match anything', js: true do
    fill_in 'titleInput', with: 'Invalid'
    expect_page_to_not_have_tag_suggestions
  end
  it 'does not show tags when content input does not match anything', js: true do
    fill_in 'contentInput', with: 'Invalid'
    expect_page_to_not_have_tag_suggestions
  end

  describe 'with tag-matching title input' do
    it 'shows tag suggestions', js: true do
      fill_in 'titleInput', with: 'tag'
      expect_page_to_have_tag_suggestions
    end

    it 'selects the first tag', js: true do
      fill_in 'titleInput', with: 'tag'
      expect(page).to have_selector 'li.Selected', text: 'tag1'
    end

    # FIXME — Keypress tests not really working yet
    # https://github.com/thoughtbot/capybara-webkit/issues/191#issuecomment-3892991
    # def keypress_on(elem, key, charCode = 0)
    #   keyCode = case key
    #     when :return then 13
    #     when :arrow_down then 40
    #     when :arrow_up then 38
    #     else key.to_i
    #   end
    #   puts elem.base.class

    #   elem.base.invoke('keypress', false, false, false, false, keyCode, charCode);
    # end

    # it 'does not change selection when pressing up arrow on first tag', js: true do
    #   fill_in 'titleInput', with: 'tag'
    #   input = find '#titleInput'
    #   keypress_on input, :arrow_up
    #   expect(page).to have_selector 'li.Selected', text: 'tag1'
    # end
    # it 'moves selection down when pressing down arrow on first tag', js: true do
    #   fill_in 'titleInput', with: 'tag'
    #   input = find '#titleInput'
    #   keypress_on input, :arrow_down
    #   expect(page).to have_selector 'li.Selected', text: 'tag2'
    # end
  end
  describe 'with tag-matching content input' do
    it 'shows tag suggestions', js: true do
      fill_in 'contentInput', with: 'tag'
      expect_page_to_have_tag_suggestions
    end

    it 'selects the first tag', js: true do
      fill_in 'contentInput', with: 'tag'
      expect(page).to have_selector 'li.Selected', text: 'tag1'
    end
  end
end