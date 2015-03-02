require 'rails_helper'

describe IdeaPresenter do
  let(:office) { new_office(location: 'Denver') }
  let(:idea_office) { new_office(location: 'All Offices') }
  let(:user) { new_user(id: 123, name: 'Dubstep Rockz', office: office) }
  let(:idea) {
    new_idea(
      title: 'play more dubstep in the office',
      description: 'some',
      user_id: user.id,
      aasm_state: 'under_consideration',
      office: idea_office
    )
  }

  let(:valid_params) {
    { idea: idea, submitter: user, vote_count: 3 }
  }

  subject(:idea_presenter) { IdeaPresenter.new(valid_params) }

  describe '.new' do
    it 'stores the idea and submitter' do
      expect(idea_presenter.idea).to eq(idea)
      expect(idea_presenter.submitter).to eq(user)
      expect(idea_presenter.vote_count).to eq(3)
    end

    it 'raises if an idea is not provided' do
      expect{
        IdeaPresenter.new(valid_params.except(:idea))
      }.to raise_error(KeyError, 'key not found: :idea')
    end

    it 'raises if a submitter is not provided' do
      expect{
        IdeaPresenter.new(valid_params.except(:submitter))
      }.to raise_error(KeyError, 'key not found: :submitter')
    end
  end

  describe '#submitted_by' do
    it 'returns the name of the user who submitted the idea' do
      expect(idea_presenter.submitted_by).to eq('Dubstep Rockz')
    end
  end

  describe '#title' do
    it 'returns the title of the idea' do
      expect(idea_presenter.title).to eq('play more dubstep in the office')
    end
  end

  describe '#submitters_office' do
    it 'returns the location of the submitters office' do
      expect(idea_presenter.submitters_office).to eq('Denver')
    end
  end

  describe '#description' do
    it 'returns the description of an idea' do
      expect(idea_presenter.description).to eq('some')
    end
  end

  describe '#current_state' do
    it 'returns the current_state of an idea' do
      expect(idea_presenter.current_state).to eq('Under Consideration')
    end
  end

  describe '#office' do
    it 'returns the office of an idea' do
      expect(idea_presenter.office).to eq('All Offices')
    end
  end

  context 'when the submission is anonymous' do
    let(:idea) {
      new_idea(
        anonymous: true,
        title: 'I want more dubstep, but I do not want people to know I like it',
        user_id: user.id
      )
    }

    describe '#submitted_by' do
      it 'returns the string Anonymous' do
        expect(idea_presenter.submitted_by).to eq('Anonymous')
      end
    end
  end
end
