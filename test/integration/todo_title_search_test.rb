require "test_helper"

class TodoTitleSearchTest < ActionDispatch::IntegrationTest
  setup do
    Todo.delete_all
    @match = Todo.create!(title: "Plan 50%_OFF\\sale", priority: :high, completed: false)
    Todo.create!(title: "Plan 500XOFF sale", priority: :high, completed: false)
    Todo.create!(title: "Plan 50%_OFF\\sale", priority: :low, completed: true)
  end

  test "literal case insensitive search composes with filters in HTML and JSON" do
    filters = { q: "  50%_off\\sale  ", status: "open", priority: "high" }
    get todos_path, params: filters
    assert_response :success
    assert_select "#todos > div", count: 1
    assert_select 'input[name="q"][value=?]', "50%_off\\sale"
    assert_select 'label[for="q"]', text: "Search titles"
    assert_select 'form[method="get"]' do
      assert_select 'input[name="status"][value="open"]'
      assert_select 'input[name="priority"][value="high"]'
    end
    assert_select 'nav[aria-label="Filter by priority"] a[href=?]', todos_path(priority: "low", status: "open", q: "50%_off\\sale")
    assert_select 'nav[aria-label="Filter by status"] a[href=?]', todos_path(status: "completed", priority: "high", q: "50%_off\\sale")

    get todos_path(format: :json), params: filters
    assert_response :success
    assert_equal [ @match.id ], response.parsed_body.map { |todo| todo["id"] }
  end

  test "absent blank and structured queries do not filter" do
    [ nil, "  ", [ "Plan" ], { title: "Plan" } ].each do |query|
      get todos_path(format: :json), params: { q: query }
      assert_response :success
      assert_equal Todo.count, response.parsed_body.size
    end
  end

  test "SQL syntax in query is treated as text" do
    get todos_path(format: :json), params: { q: "' OR 1=1 --" }
    assert_response :success
    assert_empty response.parsed_body
  end
end
