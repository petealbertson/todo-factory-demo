class RenameDueOnToDueDateInTodos < ActiveRecord::Migration[8.1]
  def change
    rename_column :todos, :due_on, :due_date
  end
end
