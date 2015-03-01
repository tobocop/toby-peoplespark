class AddStateToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :aasm_state, :string
  end
end
