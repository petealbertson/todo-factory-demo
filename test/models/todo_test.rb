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
end
