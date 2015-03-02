require 'rails_helper'

describe Office do
  let(:valid_params) {
    {
      location: 'New York'
    }
  }

  it 'can be persisted' do
    expect(Office.create(valid_params)).to be_persisted
  end

end
