class AddPriorityToTodos < ActiveRecord::Migration[8.1]
  def up
    add_column :todos, :priority, :string
    Todo.reset_column_information
    Todo.update_all(priority: "medium")
    change_column_default :todos, :priority, "medium"
    change_column_null :todos, :priority, false
  end

  def down
    remove_column :todos, :priority
  end
end
