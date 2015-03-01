class IdeasController < ApplicationController
  def index
    @idea_states = Idea.available_states
    @idea_state_filter_params = idea_state_filter_params
    @ideas = idea_state_filter_params.has_key?('all_ideas') ? Idea.all : Idea.filter_by_state(idea_state_filter_params)
  end

  def new
    @idea = Idea.new
  end

  def create
    @idea = Idea.create(idea_params)

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

  def idea_params
    params.require(:idea).permit(
      :title,
      :description,
      :single_office,
      :anonymous
    )
  end
end
