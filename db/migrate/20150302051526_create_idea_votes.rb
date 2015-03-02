class CreateIdeaVotes < ActiveRecord::Migration
  def up
    create_table :idea_votes do |t|
      t.integer   :idea_id
      t.integer   :user_id
      t.integer   :vote_count

      t.timestamps
    end
  end

  def down
    drop_table :idea_votes
  end
end
