class IdeasController < ApplicationController
  def index
    @offices = Office.order('location').all

    @idea_states = Idea.available_states
    @idea_state_filter_params = idea_state_filter_params
    @idea_office_filter_params = idea_office_filter_params

    @ideas = build_idea_presenters(
      IdeaService.find_ideas_by_state_and_office(
        @idea_state_filter_params,
        @idea_office_filter_params
      )
    )
  end

  def new
    @idea = Idea.new
  end

  def create
    @idea = Idea.create(
      idea_params.merge(
        user_id: current_user.id,
        office_id: idea_params[:single_office] == '1' ? current_user.office_id : Office.all_office_id
      )
    )

    if @idea.persisted?
      flash.notice = 'Idea created successfully'
      redirect_to ideas_path
    else
      flash.notice = 'Idea could not be created'
      render :new
    end

  end

private

  def idea_state_filter_params
    params[:idea_state] ? params[:idea_state] : {'all_ideas' => true}
  end

  def idea_office_filter_params
    params[:office_ids] ? params[:office_ids] : [Office.all_office_id.to_s]
  end

  def idea_params
    params.require(:idea).permit(
      :title,
      :description,
      :single_office,
      :anonymous
    )
  end

  def build_idea_presenters(ideas)
    ideas.map {|idea| new_idea_presenter(idea)}
  end

  def new_idea_presenter(idea)
    IdeaPresenter.new(
      idea: idea,
      submitter: idea.user
    )
  end
end
