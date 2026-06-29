require "test_helper"

class TodosToggleTest < ActionDispatch::IntegrationTest
  test "toggle flips completed and redirects to the list" do
    todo = todos(:one)
    assert_not todo.completed

    patch toggle_todo_path(todo)
    assert_response :see_other
    assert_redirected_to todos_path

    assert todo.reload.completed
  end

  test "toggle persists the change to the database" do
    todo = todos(:two)
    assert todo.completed

    patch toggle_todo_path(todo)
    assert_redirected_to todos_path
    assert_not todo.reload.completed
  end

  test "the list renders a toggle control for each todo" do
    get todos_url
    assert_response :success

    assert_select "form.toggle-complete"
    Todo.all.each do |todo|
      assert_select "form[action='#{toggle_todo_path(todo)}']"
    end
  end
end
