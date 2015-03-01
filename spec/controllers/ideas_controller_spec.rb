require 'rails_helper'

describe IdeasController do

  describe 'GET :index' do
    let(:idea) { new_idea }
    before do
      expect(Idea).to receive(:all).and_return(idea)
    end

    it 'is successful' do
      get :index

      expect(response).to be_successful
    end

    it 'assigns ideas from the database' do
      get :index

      expect(assigns(:ideas)).to be_present
      expect(assigns(:ideas)).to eq(idea)
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
