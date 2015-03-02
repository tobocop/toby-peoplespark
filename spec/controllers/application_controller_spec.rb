require 'rails_helper'

describe ApplicationController do
  describe 'current_user' do
    let(:user) { new_user }

    it 'gets the logged in user' do
      expect(User).to receive(:last).and_return(user)

      expect(controller.current_user).to eq(user)
    end

    it 'does not call the database more then once in a request' do
      expect(User).to receive(:last).exactly(1).times.and_return(user)

      controller.current_user
      controller.current_user
    end
  end
end
