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

  it 'can be persisted' do
    expect(Idea.create(valid_params)).to be_persisted
  end
end
