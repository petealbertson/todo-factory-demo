require "test_helper"

class TodoCompletionJsonTest < ActionDispatch::IntegrationTest
  setup do
    Todo.delete_all
    @open_high = Todo.create!(title: "Open high", priority: :high, completed: false)
    @done_high = Todo.create!(title: "Done high", priority: :high, completed: true)
    @open_low = Todo.create!(title: "Open low", priority: :low, completed: false)
  end

  test "JSON completion and priority filters compose" do
    assert_ids [ @open_high ], status: "open", priority: "high"
    assert_ids [ @done_high ], status: "completed", priority: "high"
    assert_ids [ @open_high, @open_low ], status: "open"
    assert_ids [ @done_high ], status: "completed"
  end

  test "JSON missing and invalid filters retain all matching records" do
    assert_ids [ @open_high, @done_high ], priority: "high"
    assert_ids [ @open_high, @done_high ], status: "all", priority: "high"
    assert_ids [ @open_high, @done_high ], status: "invalid", priority: "high"
    assert_ids [ @open_high, @open_low ], status: "open", priority: "invalid"
    assert_ids [ @open_high, @done_high, @open_low ]
    assert_ids [ @open_high, @done_high, @open_low ], status: "invalid", priority: "invalid"
  end

  private

  def assert_ids(todos, **filters)
    get todos_path(format: :json), params: filters
    assert_response :success
    assert_equal todos.map(&:id).sort, response.parsed_body.map { |todo| todo.fetch("id") }.sort
  end
end
