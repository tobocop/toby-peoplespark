require 'rails_helper'


describe 'employee ideas' do
  it 'can be added to by any employee' do

    visit ideas_path

    click_on 'Add Idea'

    expect(page).to have_content('What is your idea?')
  end

end
