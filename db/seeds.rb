Idea.destroy_all
User.destroy_all

user = User.create(
  name: 'Ollie monster',
  office_id: 1,
  profile_picture: 'dog.png'
)

my_user = User.create(
  name: 'Toby Rumans',
  office_id: 1,
  profile_picture: 'dog.png'
)

Idea.available_states.each do |state|
  14.times do |i|
    Idea.create(
      {
        title: "Idea #{i} for #{state.to_s}, all offices",
        description: 'something cool',
        single_office: i % 3 == 0, # make every 3rd submission single office
        anonymous: i % 4 == 0, #make every 4th submission anonymous
        aasm_state: state.to_s,
        user: user
      }
    )
  end
end


