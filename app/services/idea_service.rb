class IdeaService

  def self.find_ideas_by_state_and_office(state_params, office_ids)
    ideas = Idea.limit(10)
    ideas = ideas.filter_by_state(state_params) unless state_params.has_key?('all_ideas')
    ideas = ideas.filter_by_office_ids(office_ids) unless office_ids.first == 'all_offices'

    ideas.includes(:user)
  end

end
