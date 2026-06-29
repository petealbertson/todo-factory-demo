require "test_helper"

class TodosTest < ActionDispatch::IntegrationTest
  test "index renders completed count summary" do
    Todo.create!(title: "Finished todo", completed: true)
    Todo.create!(title: "Unfinished todo", completed: false)

    get todos_url

    assert_response :success
    assert_match(/Completed: 1 of 2/, response.body)
  end

  test "index renders zero counts when no todos exist" do
    get todos_url

    assert_response :success
    assert_match(/Completed: 0 of 0/, response.body)
  end
end
