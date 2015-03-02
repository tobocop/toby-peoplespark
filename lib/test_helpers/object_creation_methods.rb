module ObjectCreationMethods
  require 'ostruct'

  def new_office(options = {})
    defaults = {
      location: 'New York'
    }

    Office.new { |office| apply(office, defaults, options) }
  end

  def create_office(options = {})
    new_office(options).tap(&:save!)
  end

  def new_user(options = {})
    defaults = {
      name: 'Ollie monster',
      office_id: 1,
      profile_picture: 'dog.png'
    }

    User.new { |user| apply(user, defaults, options) }
  end

  def create_user(options = {})
    new_user(options).tap(&:save!)
  end

  def new_idea(options = {})
    defaults = {
      title: 'my idea is sick',
      description: 'no really, it is the best thing ever',
      single_office: false,
      anonymous: false,
      user_id: 123
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
