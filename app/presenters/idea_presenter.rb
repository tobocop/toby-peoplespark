class IdeaPresenter

  attr_accessor :idea, :submitter

  def initialize(params)
    self.idea = params.fetch(:idea)
    self.submitter = params.fetch(:submitter)
  end

  def submitted_by
    idea.anonymous ? 'Anonymous' : submitter.name
  end

  def title
    idea.title
  end
end
