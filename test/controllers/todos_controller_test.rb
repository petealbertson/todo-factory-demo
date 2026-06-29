require "test_helper"

class TodosControllerTest < ActionDispatch::IntegrationTest
  test "index displays created_at for each todo" do
    Todo.create!(title: "Test todo", completed: false)

    get todos_url
    assert_response :success
    assert_match "Created:", response.body
    assert_match "ago", response.body
  end
end
