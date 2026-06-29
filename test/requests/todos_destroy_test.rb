require "test_helper"

class TodosDestroyTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    @todo = todos(:one)
  end

  test "should destroy todo from the list and redirect to todos path" do
    assert_difference("Todo.count", -1) do
      delete todo_url(@todo)
    end

    assert_redirected_to todos_path
  end
end
