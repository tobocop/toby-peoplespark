class IdeaPresenter

  attr_accessor :idea, :submitter, :vote_count

  def initialize(params)
    self.idea = params.fetch(:idea)
    self.submitter = params.fetch(:submitter)
    self.vote_count = params.fetch(:vote_count)
  end

  def submitted_by
    idea.anonymous ? 'Anonymous' : submitter.name
  end

  def title
    idea.title
  end

  def submitters_office
    submitter.office.location #this triggers extra queries, refactor
  end
end
