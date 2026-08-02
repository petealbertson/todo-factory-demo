require "test_helper"

# Benchmark acceptance test for task-01-priority-filter.
# Copy to test/integration/priority_filter_test.rb and implement the feature
# so this test passes. Do NOT modify this file.
class PriorityFilterTest < ActionDispatch::IntegrationTest
  setup do
    Todo.delete_all
    @high   = Todo.create!(title: "Urgent task",   priority: :high)
    @medium = Todo.create!(title: "Normal task",   priority: :medium)
    @low    = Todo.create!(title: "Whenever task", priority: :low)
  end

  test "index shows all todos when no filter is set" do
    get todos_url
    assert_response :success
    assert_select "div[id^='todo_']", count: 3
  end

  test "index filters to only high-priority todos" do
    get todos_url(priority: "high")
    assert_response :success
    assert_select "div[id^='todo_']", count: 1
    assert_select "div[id=?]", dom_id(@high)
    assert_select "div[id=?]", dom_id(@medium), count: 0
    assert_select "div[id=?]", dom_id(@low), count: 0
  end

  test "index shows a link to filter by high priority" do
    get todos_url
    assert_select "a[href=?]", "/todos?priority=high"
  end
end
