require 'rails_helper'

describe IdeasController do

  describe 'GET :index' do
    let(:office) { new_office }
    let(:idea) { new_idea }
    let(:idea_state_filter_params) { {'all_ideas' => true} }
    let(:idea_office_filter_params) { 'does not matter what this returns' }

    before do
      allow(Office).to receive(:order).and_return(double(all: [office]))

      allow(Idea).to receive(:available_states).and_return([:state1, :state2])
      allow(IdeaService).to receive(:find_ideas_by_state_and_office).and_return([idea])

      allow(controller).to receive(:idea_state_filter_params).and_return(idea_state_filter_params)
      allow(controller).to receive(:idea_office_filter_params).and_return(idea_office_filter_params)

      allow(controller).to receive(:build_idea_presenters).and_return([idea])
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

    it 'assigns offices from the database' do
      get :index

      expect(assigns(:offices)).to be_present
      expect(assigns(:offices)).to eq([office])
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

    it 'assigns idea_office_filter_params' do
      get :index

      expect(assigns(:idea_office_filter_params)).to be_present
      expect(assigns(:idea_office_filter_params)).to eq('does not matter what this returns')
    end

    it 'uses the idea service to get the filtered ideas' do
      expect(IdeaService).to receive(:find_ideas_by_state_and_office).
        with(idea_state_filter_params, idea_office_filter_params).
        and_return([idea])

      get :index
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

    let(:user) { new_user(id: 123, office_id: 23) }

    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    it 'it creates a new idea and redirects to the index' do
      post :create, {idea: idea_params}

      idea = Idea.last
      expect(idea).to_not be_nil
      expect(idea.title).to eq('my idea is sick')
      expect(idea.description).to eq('no really, it is the best thing ever')
      expect(idea.single_office).to eq(false)
      expect(idea.anonymous).to eq(false)
      expect(idea.user_id).to eq(123)
      expect(idea.office_id).to eq(23)

      expect(flash[:notice]).to eq('Idea created successfully')
      expect(response).to redirect_to(ideas_path)
    end

    it 'renders new when the idea is not created' do
      expect(Idea).to receive(:create).
        and_return(
          double(persisted?: false)
        )

      post :create, {idea: idea_params.except(:title)}

      expect(flash[:notice]).to eq('Idea could not be created')
      expect(response).to render_template('new')
    end
  end
end
