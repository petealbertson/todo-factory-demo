class StatsService
  def self.call
    todos = Todo.all
    {
      total: todos.count,
      completed: todos.where(completed: true).count,
      overdue: todos.count { |todo| todo.overdue? }
    }
  end
end
