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
    
    sign_in
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
  # Can't send keypresses… :(
  describe 'and selecting a tag suggestion' do
    it 'puts tag text into field'
    it 'shows tag highlight'
    it 'clears tag suggestions list'
  end

  describe 'and submitting it' do
    describe 'without an embed' do
      it 'fails to save' do
        post_count = Post.count
        fill_in 'titleInput', with: 'Test title'
        fill_in 'contentInput', with: 'Hello world'
        click_button 'Publish'
        expect(Post.count).to eq(post_count)
      end
    end
    describe 'without tags' do
      it 'saves a post in the database' do
        post_count = Post.count
        fill_in 'titleInput', with: 'Test title'
        fill_in 'contentInput', with: 'Hello world'
        fill_in 'embedInput', with: '<iframe width="100%" height="300" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/151835201&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false&amp;visual=true"></iframe>'
        click_button 'Publish'
        expect(Post.count).to eq(post_count)
      end
    end
    describe 'with tags' do
      it 'saves a post, tagged text and tag ranges in the database'
    end

    # FIXME — this test is actually seeing the content in the original fields, not the new post
    it 'displays the post on the page' do
      fill_in 'titleInput', with: 'Test title'
      fill_in 'contentInput', with: 'Hello world'
      fill_in 'embedInput', with: '<iframe width="100%" height="300" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/151835201&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false&amp;visual=true"></iframe>'
      click_button 'Publish'
      expect(page).to have_content('Test title')
      expect(page).to have_content('Hello world')
      # expect(page).to have_selector('.NewPost')
    end
  end
end