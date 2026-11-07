require "test_helper"

class TodoCompletionFilterTest < ActionDispatch::IntegrationTest
  test "completion and priority compose and navigation retains filters" do
    Todo.delete_all
    open_todo = Todo.create!(title: "Open high task", priority: :high, completed: false)
    done_todo = Todo.create!(title: "Done high task", priority: :high, completed: true)
    Todo.create!(title: "Open low task", priority: :low, completed: false)

    get todos_path, params: { status: "open", priority: "high" }
    assert_response :success
    assert_select "#todos", text: /#{open_todo.title}/
    assert_select "#todos", text: /#{done_todo.title}/, count: 0
    assert_select "#todos", text: /Open low task/, count: 0
    assert_select 'nav[aria-label="Filter by priority"] a[href=?]', todos_path(priority: "low", status: "open")
    assert_select 'nav[aria-label="Filter by status"] a[href=?]', todos_path(status: "completed", priority: "high")

    get todos_path, params: { status: "completed", priority: "high" }
    assert_select "#todos", text: /#{done_todo.title}/
    assert_select "#todos", text: /#{open_todo.title}/, count: 0

    [nil, "invalid"].each do |status|
      get todos_path, params: { status: status, priority: "high" }
      assert_select "#todos", text: /#{open_todo.title}/
      assert_select "#todos", text: /#{done_todo.title}/
    end
  end
end
