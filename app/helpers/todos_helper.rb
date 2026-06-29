module TodosHelper
  def todo_due_classes(todo)
    "overdue" if todo.overdue?
  end
end
