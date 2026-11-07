module TodosHelper
  def active_todo_status
    params[:status] if %w[open completed].include?(params[:status])
  end

  def active_todo_priority
    params[:priority] if Todo.priorities.key?(params[:priority])
  end

  def todo_due_classes(todo)
    "overdue" if todo.overdue?
  end
end
