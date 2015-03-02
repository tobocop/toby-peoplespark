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

  describe '.all_office_id' do
    let!(:all_office) { create_office(location: 'All Offices')}

    before do
    end

    it 'returns the office id for an office record with location of All Offices' do
      create_office #another office to make sure we're not just pulling one

      expect(Office.all_office_id).to eq(all_office.id)
    end
  end

end
