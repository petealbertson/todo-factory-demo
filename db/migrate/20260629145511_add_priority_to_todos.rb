class AddPriorityToTodos < ActiveRecord::Migration[8.1]
  def change
    add_column :todos, :priority, :string, default: "medium", null: false
  end
end
