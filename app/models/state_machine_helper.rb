module StateMachineHelper
  STATE_COLUMN = 'aasm_state'

  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
    def current_state
      self.aasm.current_state
    end
  end

  module ClassMethods
    def available_states
      self.aasm.states.map(&:name)
    end
  end
end
