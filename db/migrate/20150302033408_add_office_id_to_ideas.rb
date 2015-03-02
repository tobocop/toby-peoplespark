class AddOfficeIdToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :office_id, :integer
  end
end
