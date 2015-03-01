require 'rails_helper'

describe Idea do
  let(:valid_params) {
    {
      title: 'my idea is sick',
      description: 'no really, it is the best thing ever',
      single_office: false,
      anonymous: false
    }
  }

  it { should validate_presence_of(:title) }

  subject(:idea) {Idea.create(valid_params)}

  it 'can be persisted' do
    expect(idea).to be_persisted
  end

  context 'states' do
    it 'should have a default state of under_consideration' do
      expect(idea.current_state).to eq(:under_consideration)
    end

    it 'should have the states of planned, in_progress, and completed' do
      expect(Idea.available_states).to eq(
        [
          :under_consideration,
          :planned,
          :in_progress,
          :completed
        ]
      )
    end
  end

  describe 'filter_by_state' do

    let!(:idea) { create_idea(aasm_state: 'under_consideration') }

    it 'returns ideas given a state' do
      idea.update_attribute('aasm_state', 'planned')

      expect(Idea.filter_by_state('planned' => true).length).to eq(1)
    end

    it 'returns ideas given multiple states' do
      create_idea(aasm_state: 'planned')

      expect(Idea.filter_by_state('planned' => true, 'under_consideration' => true).length).to eq(2)
    end

    it 'does not return ideas of the incorrect state' do
      expect(Idea.filter_by_state('planned' => true).length).to eq(0)
    end
  end

end
