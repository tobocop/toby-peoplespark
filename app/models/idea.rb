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

  def self.filter_by_state(states)
    where("#{STATE_COLUMN} IN (?)", states.keys)
  end

  def self.filter_by_office_ids(office_ids)
    where("office_id IN (?)", office_ids)
  end

end
