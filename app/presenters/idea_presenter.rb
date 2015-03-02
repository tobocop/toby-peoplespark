class IdeaPresenter

  attr_accessor :idea, :submitter, :vote_count

  delegate :title, :description, to: :idea

  def initialize(params)
    self.idea = params.fetch(:idea)
    self.submitter = params.fetch(:submitter)
    self.vote_count = params.fetch(:vote_count)
  end

  def current_state
    idea.current_state.to_s.gsub(/_/, ' ').titlecase
  end

  def office
    idea.office.location #this triggers extra queries, refactor
  end

  def submitted_by
    idea.anonymous ? 'Anonymous' : submitter.name
  end

  def submitters_office
    submitter.office.location #this triggers extra queries, refactor
  end
end
