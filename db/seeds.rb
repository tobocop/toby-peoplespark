Idea.destroy_all
User.destroy_all
Office.destroy_all
IdeaVote.destroy_all

Office.create(location: 'All Offices')
office = Office.create(location: 'Denver')
my_office = Office.create(location: 'Seattle')

user = User.create(
  name: 'Ollie monster',
  office: office,
  profile_picture: 'dog.png'
)

my_user = User.create(
  name: 'Toby Rumans',
  office: my_office,
  profile_picture: 'dog.png'
)

Idea.available_states.each do |state|
  14.times do |i|
    idea = Idea.create(
      {
        title: "Idea #{i} for #{state.to_s}, all offices",
        description: 'something cool',
        single_office: i % 3 == 0, # make every 3rd submission single office
        anonymous: i % 4 == 0, #make every 4th submission anonymous
        aasm_state: state.to_s,
        user: user,
        office_id: office.id
      }
    )

    (i * 2).times do |n|
      IdeaVote.create(
        user_id: my_user.id,
        idea_id: idea.id,
        vote_count: 1
      )
    end
  end
end


