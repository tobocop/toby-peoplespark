require 'rails_helper'

describe IdeaService do
    describe '.find_ideas_by_state_and_office' do
      let(:state_params) { {'all_ideas' => true} }
      let(:office_params) { ['all_offices'] }

      let(:limit_double) { double('limit query', includes: true) }
      let(:filter_by_state_double) { double('state filtered query', includes: true) }
      let(:filter_by_office_ids_double) { double('office filtered query', includes: true) }

      before do
        allow(Idea).to receive(:limit).and_return(limit_double)
      end

      it 'only gets 10 ideas' do
        expect(Idea).to receive(:limit).and_return(limit_double)

        IdeaService.find_ideas_by_state_and_office(state_params, office_params)
      end

      it 'filters by state if all_ideas is not present in state_params' do
        state_params = { 'planned' => true }

        expect(limit_double).to receive(:filter_by_state).
          with(state_params).
          and_return(filter_by_state_double)

        IdeaService.find_ideas_by_state_and_office(state_params, office_params)
      end

      it 'filters by office if all_offices is not present in office_params' do
        office_params = ['1', '2', '3']

        expect(limit_double).to receive(:filter_by_office_ids).
          with(office_params).
          and_return(filter_by_office_ids_double)

        IdeaService.find_ideas_by_state_and_office(state_params, office_params)
      end

      it 'filters by state and office if both have values other then all' do
        office_params = ['1', '2', '3']
        state_params = { 'planned' => true }

        expect(limit_double).to receive(:filter_by_state).
          with(state_params).
          and_return(filter_by_state_double)

        expect(filter_by_state_double).to receive(:filter_by_office_ids).
          with(office_params).
          and_return(filter_by_office_ids_double)

        IdeaService.find_ideas_by_state_and_office(state_params, office_params)
      end

      it 'includes the user in the return' do
        expect(limit_double).to receive(:includes).with(:user).and_return('users!')

        expect(IdeaService.find_ideas_by_state_and_office(state_params, office_params)).to eq('users!')
      end
    end
end
