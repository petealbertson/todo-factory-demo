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

  test "create a todo with due_date" do
    date = Date.current + 3

    assert_difference("Todo.count") do
      post todos_url, params: { todo: { title: "Scheduled", due_date: date } }
    end

    todo = Todo.last
    assert_equal date, todo.due_date
    assert_redirected_to todo_url(todo)
  end

  test "update a todo due_date" do
    todo = Todo.create!(title: "Reschedule me")
    date = Date.current + 5

    patch todo_url(todo), params: { todo: { due_date: date } }

    assert_redirected_to todo_url(todo)
    assert_equal date, todo.reload.due_date
  end

  test "index sorts todos by due_date with nulls last" do
    later = Todo.create!(title: "Later", due_date: Date.current + 2)
    earlier = Todo.create!(title: "Earlier", due_date: Date.current + 1)
    no_date = Todo.create!(title: "No date")

    get todos_url
    assert_response :success

    later_pos = response.body.index("Later")
    earlier_pos = response.body.index("Earlier")
    no_date_pos = response.body.index("No date")

    assert_operator earlier_pos, :<, later_pos
    assert_operator later_pos, :<, no_date_pos
  end

  test "index marks overdue todos" do
    overdue = Todo.create!(title: "Late", due_date: Date.current - 1, completed: false)

    get todos_url
    assert_response :success
    assert_select "#todo_#{overdue.id}.overdue"
  end
end
