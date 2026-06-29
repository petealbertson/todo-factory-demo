require "test_helper"

class TodoTest < ActiveSupport::TestCase
  test "defines priority enum values" do
    assert_equal({ "low" => "low", "medium" => "medium", "high" => "high" }, Todo.priorities)
  end

  test "defaults priority to medium" do
    todo = Todo.new(title: "A new todo")
    assert_equal "medium", todo.priority
  end

  test "accepts valid priority values" do
    assert Todo.new(title: "Low", priority: :low).valid?
    assert Todo.new(title: "Medium", priority: :medium).valid?
    assert Todo.new(title: "High", priority: :high).valid?
  end

  test "is overdue when due_date is in the past and not completed" do
    todo = Todo.new(title: "Late", due_date: Date.current - 1, completed: false)
    assert todo.overdue?
  end

  test "is not overdue when due_date is today" do
    todo = Todo.new(title: "Due today", due_date: Date.current, completed: false)
    assert_not todo.overdue?
  end

  test "is not overdue when completed" do
    todo = Todo.new(title: "Done late", due_date: Date.current - 1, completed: true)
    assert_not todo.overdue?
  end

  test "is not overdue when due_date is blank" do
    todo = Todo.new(title: "No date", completed: false)
    assert_not todo.overdue?
  end
end
