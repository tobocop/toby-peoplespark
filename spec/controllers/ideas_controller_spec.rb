require 'rails_helper'

describe IdeasController do

  describe 'GET :index' do
    let(:idea) { new_idea }
    let(:idea_state_filter_params) { {'all_ideas' => true} }

    before do
      allow(Idea).to receive(:available_states).and_return([:state1, :state2])
      allow(Idea).to receive(:all).and_return([idea])
      allow(Idea).to receive(:filter_by_state).and_return([idea])
      allow(controller).to receive(:idea_state_filter_params).and_return(idea_state_filter_params)
    end

    it 'is successful' do
      get :index

      expect(response).to be_successful
    end

    it 'assigns ideas from the database' do
      get :index

      expect(assigns(:ideas)).to be_present
      expect(assigns(:ideas)).to eq([idea])
    end

    it 'assigns idea_states' do
      get :index

      expect(assigns(:idea_states)).to be_present
      expect(assigns(:idea_states)).to eq([:state1, :state2])
    end

    it 'assigns idea_state_filter_params' do
      get :index

      expect(assigns(:idea_state_filter_params)).to be_present
      expect(assigns(:idea_state_filter_params)).to eq({'all_ideas' => true})
    end

    context 'when all_ideas is in params' do
      it 'returns all params' do
        expect(Idea).to receive(:all)

        get :index
      end
    end

    context 'when all_ideas is not in params' do
      let(:idea_state_filter_params) { {'something_else' => true} }

      it 'calls ideas to filter by state' do
        expect(Idea).to receive(:filter_by_state).
          with(idea_state_filter_params)

        get :index
      end
    end

  end

  describe 'GET :new' do
    it 'is successful' do
      get :new

      expect(response).to be_successful
    end

    it 'assigns a new idea' do
      get :new

      expect(assigns(:idea)).to be_present
      expect(assigns(:idea).class).to be(Idea)
    end
  end

  describe 'POST :create' do
    let(:idea_params) {
      {
        title: 'my idea is sick',
        description: 'no really, it is the best thing ever',
        single_office: false,
        anonymous: false
      }
    }

    it 'it creates a new idea and redirects to the index' do
      post :create, {idea: idea_params}

      idea = Idea.last
      expect(idea).to_not be_nil
      expect(idea.title).to eq('my idea is sick')
      expect(idea.description).to eq('no really, it is the best thing ever')
      expect(idea.single_office).to eq(false)
      expect(idea.anonymous).to eq(false)

      expect(flash[:notice]).to eq('Idea created successfully')
      expect(response).to redirect_to(ideas_path)
    end

    it 'renders new when the idea is not created' do
      expect(Idea).to receive(:create).
        with(idea_params.except(:title)).
        and_return(
          double(persisted?: false)
        )

      post :create, {idea: idea_params.except(:title)}

      expect(flash[:notice]).to eq('Idea could not be created')
      expect(response).to render_template('new')
    end
  end
end
