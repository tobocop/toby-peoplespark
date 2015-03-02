class Idea < ActiveRecord::Base
  include AASM
  include StateMachineHelper

  aasm do
    state :under_consideration, initial: true
    state :planned
    state :in_progress
    state :completed
  end

  validates_presence_of :title

  belongs_to :user
  belongs_to :office
  has_many :idea_votes

  def self.filter_by_state(states)
    where("#{STATE_COLUMN} IN (?)", states.keys)
  end

  def self.filter_by_office_ids(office_ids)
    where("office_id IN (?)", office_ids)
  end

  def self.ordered_by_vote_count
    select('ideas.*, sum(idea_votes.vote_count) as idea_vote_count').
      joins(:idea_votes).
      group('ideas.id').
      order('sum(idea_votes.vote_count) desc')
  end
end
