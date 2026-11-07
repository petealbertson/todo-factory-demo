require "test_helper"

class TodoTitleOrderTest < ActionDispatch::IntegrationTest
  setup do
    Todo.delete_all
    @zebra = Todo.create!(title: "Zebra", priority: :high, due_date: Date.yesterday)
    @alpha = Todo.create!(title: "alpha", priority: :low)
    @tie = Todo.create!(title: "ALPHA", priority: :high)
  end

  test "title ordering is case insensitive with id ties in HTML and JSON" do
    get todos_url, params: { sort: "title" }
    assert_response :success
    assert_select "#todos > div", count: 3
    ids = css_select("#todos > div").map { |node| node["id"] }
    assert_equal [ @alpha, @tie, @zebra ].map { |todo| "todo_#{todo.id}" }, ids

    get todos_url(format: :json), params: { sort: "title" }
    assert_equal [ @alpha.id, @tie.id, @zebra.id ], response.parsed_body.pluck("id")
  end

  test "missing invalid and structured sorts retain default order" do
    [ nil, "unknown", "title DESC", [ "title" ], { field: "title" } ].each do |sort|
      get todos_url(format: :json), params: { sort: sort }
      assert_response :success
      assert_equal Todo.ordered.pluck(:id), response.parsed_body.pluck("id")
    end
  end

  test "title order composes with all filters" do
    get todos_url(format: :json), params: { sort: "title", q: "alp", priority: "high", status: "open" }
    assert_equal [ @tie.id ], response.parsed_body.pluck("id")
  end

  test "navigation and search preserve active filters and default clears only sort" do
    get todos_url, params: { sort: "title", q: "alp", priority: "high", status: "open" }
    assert_select "form input[name=sort][value=title]"
    assert_select "a", text: "Title" do |links|
      assert_equal({ "q" => "alp", "priority" => "high", "status" => "open", "sort" => "title" }, query_for(links.first))
    end
    assert_select "a", text: "Default order" do |links|
      assert_equal({ "q" => "alp", "priority" => "high", "status" => "open" }, query_for(links.first))
    end
    css_select("nav[aria-label='Filter by priority'] a, nav[aria-label='Filter by status'] a").each do |link|
      assert_equal "title", query_for(link)["sort"]
      assert_equal "alp", query_for(link)["q"]
    end
  end

  private
    def query_for(link)
      Rack::Utils.parse_nested_query(URI.parse(link["href"]).query)
    end
end
