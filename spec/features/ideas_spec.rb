require 'rails_helper'

describe 'employee ideas' do
  let!(:office) { create_office(location: 'New York') }
  let!(:user) { create_user(name: 'Toby Awesomesauce', office: office) }

  it 'can be added to by any employee' do
    visit ideas_path

    click_on 'Add Idea'

    expect(page).to have_content('What is your idea?')
    expect(page).to have_content('This idea is only relevant to my office (New York)')

    click_on 'Share my idea'

    expect(page).to have_content('Idea could not be created')
    expect(page).to have_content("Title can't be blank")

    fill_in 'idea_title', with: 'My new idea'

    click_on 'Share my idea'

    expect(page).to have_content('Idea created successfully')

    uncheck 'all_offices'
    check 'New York'
    click_on 'filter'

    within '.ideasList' do
      expect(page).to have_content('My new idea')
      expect(page).to have_content('By Toby Awesomesauce')
      expect(page).to have_content('New York Office')
    end

  end

  it 'can be filtered by status' do
    create_idea(aasm_state: 'under_consideration', title: 'my new unplanned idea', user: user)
    create_idea(aasm_state: 'planned', title: 'my idea that is planned', user: user)
    create_idea(aasm_state: 'in_progress', title: 'my idea that is in progress', user: user)
    create_idea(aasm_state: 'completed', title: 'my idea that is completed', user: user)

    visit ideas_path

    within '.js-ideasStatusFilters' do
        expect(page).to have_content('All Ideas')
        expect(page).to have_content('Under consideration')
        expect(page).to have_content('Planned')
        expect(page).to have_content('In progress')
        expect(page).to have_content('Completed')
    end

    expect(page).to have_content('my new unplanned idea')
    expect(page).to have_content('my idea that is planned')
    expect(page).to have_content('my idea that is in progress')
    expect(page).to have_content('my idea that is completed')

    uncheck 'all_ideas'
    check 'under_consideration'
    click_on 'filter'

    expect(page).to have_content('my new unplanned idea')
    expect(page).to_not have_content('my idea that is planned')
    expect(page).to_not have_content('my idea that is in progress')
    expect(page).to_not have_content('my idea that is completed')

    uncheck 'under_consideration'
    check 'planned'
    click_on 'filter'

    expect(page).to_not have_content('my new unplanned idea')
    expect(page).to have_content('my idea that is planned')
    expect(page).to_not have_content('my idea that is in progress')
    expect(page).to_not have_content('my idea that is completed')

    uncheck 'planned'
    check 'in_progress'
    click_on 'filter'

    expect(page).to_not have_content('my new unplanned idea')
    expect(page).to_not have_content('my idea that is planned')
    expect(page).to have_content('my idea that is in progress')
    expect(page).to_not have_content('my idea that is completed')

    check 'completed'
    click_on 'filter'

    expect(page).to_not have_content('my new unplanned idea')
    expect(page).to_not have_content('my idea that is planned')
    expect(page).to have_content('my idea that is in progress')
    expect(page).to have_content('my idea that is completed')
  end

  it 'can be filtered by office' do
    denver = create_office(location: 'Denver')
    seattle = create_office(location: 'Seattle')

    create_idea(title: 'my new york idea', user: user, office_id: office.id)
    create_idea(title: 'my denver idea', user: user, office_id: denver.id)
    create_idea(title: 'my seattle idea', user: user, office_id: seattle.id)

    visit ideas_path

    within '.js-ideasOfficeFilters' do
        expect(page).to have_content('All Offices')
        expect(page).to have_content('Denver')
        expect(page).to have_content('Seattle')
        expect(page).to have_content('New York')
    end


    expect(page).to have_content('my denver idea')
    expect(page).to have_content('my seattle idea')
    expect(page).to have_content('my new york idea')

    uncheck 'all_offices'
    check 'Denver'
    click_on 'filter'

    expect(page).to have_content('my denver idea')
    expect(page).to_not have_content('my seattle idea')
    expect(page).to_not have_content('my new york idea')

    uncheck 'Denver'
    check 'Seattle'
    click_on 'filter'

    expect(page).to_not have_content('my denver idea')
    expect(page).to have_content('my seattle idea')
    expect(page).to_not have_content('my new york idea')

    check 'New York'
    click_on 'filter'

    expect(page).to_not have_content('my denver idea')
    expect(page).to have_content('my seattle idea')
    expect(page).to have_content('my new york idea')
  end
end
