require 'rails_helper'

describe 'employee ideas' do
  let!(:user) { create_user(name: 'Toby Awesomesauce') }

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

    within '.ideasList' do
      expect(page).to have_content('My new idea')
      expect(page).to have_content('By Toby Awesomesauce')
    end

  end

  it 'can be filtered by status' do
    create_idea(aasm_state: 'under_consideration', title: 'my new unplanned idea', user: user)
    create_idea(aasm_state: 'planned', title: 'my idea that is planned', user: user)
    create_idea(aasm_state: 'in_progress', title: 'my idea that is in progress', user: user)
    create_idea(aasm_state: 'completed', title: 'my idea that is completed', user: user)

    visit ideas_path

    expect(page).to have_content('my new unplanned idea')
    expect(page).to have_content('my idea that is planned')
    expect(page).to have_content('my idea that is in progress')
    expect(page).to have_content('my idea that is completed')

    uncheck 'idea_state[all_ideas]'
    check 'idea_state[under_consideration]'
    click_on 'filter'

    expect(page).to have_content('my new unplanned idea')
    expect(page).to_not have_content('my idea that is planned')
    expect(page).to_not have_content('my idea that is in progress')
    expect(page).to_not have_content('my idea that is completed')

    uncheck 'idea_state[under_consideration]'
    check 'idea_state[planned]'
    click_on 'filter'

    expect(page).to_not have_content('my new unplanned idea')
    expect(page).to have_content('my idea that is planned')
    expect(page).to_not have_content('my idea that is in progress')
    expect(page).to_not have_content('my idea that is completed')

    uncheck 'idea_state[planned]'
    check 'idea_state[in_progress]'
    click_on 'filter'

    expect(page).to_not have_content('my new unplanned idea')
    expect(page).to_not have_content('my idea that is planned')
    expect(page).to have_content('my idea that is in progress')
    expect(page).to_not have_content('my idea that is completed')

    uncheck 'idea_state[in_progress]'
    check 'idea_state[completed]'
    click_on 'filter'

    expect(page).to_not have_content('my new unplanned idea')
    expect(page).to_not have_content('my idea that is planned')
    expect(page).to_not have_content('my idea that is in progress')
    expect(page).to have_content('my idea that is completed')
  end
end
