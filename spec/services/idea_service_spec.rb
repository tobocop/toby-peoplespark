require 'rails_helper'

describe IdeaService do
    describe '.find_ideas_by_state_and_office' do
      let(:state_params) { {'all_ideas' => true} }
      let(:office_params) { ['1'] }

      let(:includes_double) { double(ordered_by_vote_count: true) }
      let(:limit_double) {
        double(
          'limit query',
          includes: includes_double,
          filter_by_office_ids: filter_by_office_ids_double
        )
      }
      let(:filter_by_state_double) {
        double(
          'state filtered query',
          includes: includes_double,
          filter_by_office_ids: filter_by_office_ids_double
        )
      }
      let(:filter_by_office_ids_double) {
        double(
          'office filtered query',
          includes: includes_double
        )
      }

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

      it 'filters by office ids passed in' do
        expect(limit_double).to receive(:filter_by_office_ids).
          with(office_params).
          and_return(filter_by_office_ids_double)

        IdeaService.find_ideas_by_state_and_office(state_params, office_params)
      end

      it 'filters by state and office if both have values other then all' do
        state_params = { 'planned' => true }

        expect(limit_double).to receive(:filter_by_state).
          with(state_params).
          and_return(filter_by_state_double)

        expect(filter_by_state_double).to receive(:filter_by_office_ids).
          with(office_params).
          and_return(filter_by_office_ids_double)

        IdeaService.find_ideas_by_state_and_office(state_params, office_params)
      end

      it 'includes the user in the return and orders by vote count' do
        expect(filter_by_office_ids_double).to receive(:includes).with(:user).and_return(includes_double)
        expect(includes_double).to receive(:ordered_by_vote_count).and_return('ideas!')


        expect(IdeaService.find_ideas_by_state_and_office(state_params, office_params)).to eq('ideas!')
      end
    end
end
