require 'rails_helper'

describe 'employee ideas' do
  let!(:office) { create_office(location: 'New York') }
  let!(:user) { create_user(name: 'Toby Awesomesauce', office: office) }
  let!(:all_office) { create_office(location: 'All Offices') }

  it 'can be added to by any employee' do
    visit ideas_path

    find('.js-modal-trigger').click()

    expect(page).to have_content('What is your idea?')
    expect(page).to have_content('This idea is only relevant to my office (New York)')

    click_on 'Share my idea'

    expect(page).to have_content('Idea could not be created')
    expect(page).to have_content("Title can't be blank")

    fill_in 'idea_title', with: 'My new idea'

    click_on 'Share my idea'

    expect(page).to have_content('Idea created successfully')

    within '.ideasList' do
      expect(page).to have_content('My new idea')
      expect(page).to have_content('By Toby Awesomesauce')
      expect(page).to have_content('New York Office')
    end

    uncheck 'All Offices'
    check 'New York'
    click_on 'filter'

    within '.ideasList' do
      expect(page).to_not have_content('My new idea')
    end

    find('.js-modal-trigger').click()

    fill_in 'idea_title', with: 'My new idea just for my office'
    check 'idea_single_office'

    click_on 'Share my idea'

    expect(page).to have_content('Idea created successfully')

    uncheck 'All Offices'
    check 'New York'
    click_on 'filter'

    within '.ideasList' do
      expect(page).to have_content('My new idea just for my office')
    end

  end

  it 'can be filtered by status' do
    under_consideration_idea = create_idea(aasm_state: 'under_consideration', title: 'my new unplanned idea', user: user, office_id: all_office.id)
    create_idea_vote(idea_id: under_consideration_idea.id)

    planned_idea = create_idea(aasm_state: 'planned', title: 'my idea that is planned', user: user, office_id: all_office.id)
    create_idea_vote(idea_id: planned_idea.id)

    in_progress_idea = create_idea(aasm_state: 'in_progress', title: 'my idea that is in progress', user: user, office_id: all_office.id)
    create_idea_vote(idea_id: in_progress_idea.id)

    completed_idea = create_idea(aasm_state: 'completed', title: 'my idea that is completed', user: user, office_id: all_office.id)
    create_idea_vote(idea_id: completed_idea.id)


    visit ideas_path

    within '.js-ideasStatusFilters' do
        expect(page).to have_content('All Ideas')
        expect(page).to have_content('Under Consideration')
        expect(page).to have_content('Planned')
        expect(page).to have_content('In Progress')
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

    new_york_idea = create_idea(title: 'my new york idea', user: user, office_id: office.id)
    create_idea_vote(idea_id: new_york_idea.id)
    denver_idea = create_idea(title: 'my denver idea', user: user, office_id: denver.id)
    create_idea_vote(idea_id: denver_idea.id)
    seattle_idea = create_idea(title: 'my seattle idea', user: user, office_id: seattle.id)
    create_idea_vote(idea_id: seattle_idea.id)

    visit ideas_path

    within '.js-ideasOfficeFilters' do
        expect(page).to have_content('All Offices')
        expect(page).to have_content('Denver')
        expect(page).to have_content('Seattle')
        expect(page).to have_content('New York')
    end


    expect(page).to_not have_content('my denver idea')
    expect(page).to_not have_content('my seattle idea')
    expect(page).to_not have_content('my new york idea')

    uncheck 'All Offices'
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
