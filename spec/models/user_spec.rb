require 'rails_helper'

describe User do
  let(:valid_params) {
    {
      name: 'Ollie monster',
      office_id: 1,
      profile_picture: 'dog.png'
    }
  }

  it { should belong_to(:office) }

  it 'can be persisted' do
    expect(User.create(valid_params)).to be_persisted
  end

end
