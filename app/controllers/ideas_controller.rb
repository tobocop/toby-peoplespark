class IdeasController < ApplicationController
  def index
    @ideas = Idea.all
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

  def idea_params
    params.require(:idea).permit(
      :title,
      :description,
      :single_office,
      :anonymous
    )
  end
end
