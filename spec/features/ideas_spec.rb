require 'rails_helper'


describe 'employee ideas' do
  it 'can be added to by any employee' do
    visit ideas_path

    click_on 'Add Idea'

    expect(page).to have_content('What is your idea?')

    click_on 'Share my idea'

    expect(page).to have_content('Idea could not be created')
    expect(page).to have_content("Title can't be blank")

    fill_in 'idea_title', with: 'My new idea'

    click_on 'Share my idea'

    expect(page).to have_content('Idea created successfully')

    within '.ideas' do
      expect(page).to have_content('My new idea')
    end

  end

  it 'can be filtered by status' do
    create_idea()
  end
end
