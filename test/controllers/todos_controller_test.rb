require "test_helper"

class TodosControllerTest < ActionDispatch::IntegrationTest
  test "index displays created_at for each todo" do
    Todo.create!(title: "Test todo", completed: false)

    get todos_url
    assert_response :success
    assert_match "Created:", response.body
    assert_match "ago", response.body
  end

  test "index renders priority badges and sorts high first" do
    low = Todo.create!(title: "Low priority", priority: :low)
    high = Todo.create!(title: "High priority", priority: :high)
    medium = Todo.create!(title: "Medium priority", priority: :medium)

    get todos_url

    assert_response :success
    assert_select "#todo_#{high.id} .priority-badge", text: "high"
    assert_select "#todo_#{medium.id} .priority-badge", text: "medium"
    assert_select "#todo_#{low.id} .priority-badge", text: "low"

    high_pos = response.body.index("High priority")
    medium_pos = response.body.index("Medium priority")
    low_pos = response.body.index("Low priority")
    assert_operator high_pos, :<, medium_pos
    assert_operator medium_pos, :<, low_pos
  end

  test "create a todo with priority high" do
    assert_difference("Todo.count") do
      post todos_url, params: { todo: { title: "Urgent", priority: "high" } }
    end

    todo = Todo.last
    assert_equal "high", todo.priority
    assert_redirected_to todo_url(todo)
  end
end
