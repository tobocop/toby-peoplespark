class CreateIdeas < ActiveRecord::Migration
  def up
    create_table :ideas do |t|
      t.string :title
      t.string :description
      t.boolean :single_office
      t.boolean :anonymous

      t.timestamps
    end
  end

  def down
    drop_table :ideas
  end
end
