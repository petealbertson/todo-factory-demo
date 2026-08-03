require "test_helper"

# Benchmark acceptance test for the agentic task (dashboard integration).
# Copy to test/integration/dashboard_benchmark_test.rb and implement the
# feature so this test passes. Do NOT modify this file.
class DashboardBenchmarkTest < ActionDispatch::IntegrationTest
  setup do
    Todo.delete_all
    Tag.delete_all
    @todo    = Todo.create!(title: "Ship it",    priority: :high,   completed: false)
    @overdue = Todo.create!(title: "Late one",   priority: :low,    completed: false, due_date: Date.current - 2)
    @done    = Todo.create!(title: "Done deal",  priority: :medium, completed: true)
    @todo.tags.create!(name: "urgent")
  end

  # Deliverable A — stats JSON endpoint
  test "GET /stats.json returns total, completed, and overdue counts" do
    get "/stats", params: { format: :json }
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 3, body["total"]
    assert_equal 1, body["completed"]
    assert_equal 1, body["overdue"]
  end

  # Deliverable B — tags render on a todo's show page
  test "a todo's tags render on its show page" do
    get todo_url(@todo)
    assert_response :success
    assert_select "span.tag", text: "urgent"
  end

  # Deliverable C — dashboard integrates stats + the todo list (with tags)
  test "GET /dashboard shows a stats summary and the tagged todo" do
    get "/dashboard"
    assert_response :success
    assert_select "h1", text: /dashboard/i
    assert_match(/total/i, response.body)
    assert_select "span.tag", text: "urgent"
  end
end
