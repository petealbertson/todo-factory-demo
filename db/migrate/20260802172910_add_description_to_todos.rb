class AddDescriptionToTodos < ActiveRecord::Migration[8.1]
  def change
    add_column :todos, :description, :text
  end
end
