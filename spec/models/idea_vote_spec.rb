require 'rails_helper'

describe IdeaVote do
  let(:valid_params) {
    {
      idea_id: 3,
      user_id: 8,
      vote_count: 1
    }
  }

  it 'can be persisted' do
    expect(IdeaVote.create(valid_params)).to be_persisted
  end

end
