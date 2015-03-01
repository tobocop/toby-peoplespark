module ObjectCreationMethods
  require 'ostruct'

  def new_idea(options = {})
    defaults = {
      title: 'my idea is sick',
      description: 'no really, it is the best thing ever',
      single_office: false,
      anonymous: false
    }

    Idea.new { |idea| apply(idea, defaults, options) }
  end

  def create_idea(options = {})
    new_idea(options).tap(&:save!)
  end

  def apply(object, defaults, overrides)
    options = defaults.merge(overrides)
    options.each do |method, value_or_proc|
      object.send("#{method}=", value_or_proc.is_a?(Proc) ? value_or_proc.call : value_or_proc)
    end
  end
end
