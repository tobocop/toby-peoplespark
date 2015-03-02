require 'rails_helper'

describe Idea do
  let(:valid_params) {
    {
      title: 'my idea is sick',
      description: 'no really, it is the best thing ever',
      single_office: false,
      anonymous: false,
      user_id: 1,
      office_id: 34
    }
  }

  it { should validate_presence_of(:title) }
  it { should belong_to(:user) }
  it { should have_many(:idea_votes) }

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

  describe '.filter_by_state' do
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

  describe '.filter_by_office_ids' do
    let!(:idea) { create_idea(office_id: 2) }

    it 'returns matching ideas given an array of office_ids' do
      create_idea(office_id: 1)

      expect(Idea.filter_by_office_ids([2]).length).to eq(1)
      expect(Idea.filter_by_office_ids([1, 2]).length).to eq(2)
    end
  end

  describe '.ordered_by_vote_count' do
    let(:first_idea) { create_idea }
    let(:second_idea) { create_idea }

    before do
      create_idea_vote(idea_id: second_idea.id, user_id: 3)

      create_idea_vote(idea_id: first_idea.id, user_id: 3)
      create_idea_vote(idea_id: first_idea.id, user_id: 3)
    end

    it 'returns ideas ordered by total votes' do
      expect(Idea.ordered_by_vote_count).to eq([first_idea, second_idea])
    end
  end

end
