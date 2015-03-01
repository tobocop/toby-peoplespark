Idea.destroy_all

Idea.available_states.each do |state|
  14.times do |i|
    Idea.create(
      {
        title: "Idea #{i} for #{state.to_s}, all offices",
        description: 'something cool',
        single_office: false,
        anonymous: false,
        aasm_state: state.to_s
      }
    )
  end
end


