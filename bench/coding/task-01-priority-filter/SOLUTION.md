# Solution: Task 01 — Priority filter (ANSWER KEY, for the human judge only)

## A clean implementation

**Model** (`app/models/todo.rb`):
```ruby
scope :with_priority, ->(priority) { where(priority: priority) if priority }
```

**Controller** (`app/controllers/todos_controller.rb`):
```ruby
def index
  @todos = Todo.ordered.with_priority(params[:priority])
  # or: Todo.ordered.merge(params[:priority] ? Todo.where(priority: params[:priority]) : Todo.all)
end
```

**View** (`app/views/todos/index.html.erb`) — add filter links above the list:
```erb
<nav class="priority-filters">
  <%= link_to "All", todos_path %>
  <%= link_to "High", todos_path(priority: "high") %>
  <%= link_to "Medium", todos_path(priority: "medium") %>
  <%= link_to "Low", todos_path(priority: "low") %>
</nav>
```

## What to look for in the model's output

- ✅ Test passes (`bin/rails test` green).
- ✅ Uses a scope (not inlined SQL in the controller).
- ✅ Filter is composable with `ordered` (doesn't reorder).
- ✅ Handles an unknown/blank priority gracefully (shows all, not 500).
- ✅ View has clickable filter links matching the test's `a[href]`.
- ✅ No mass-assignment / strong-params issues.
- ❌ Hardcoded SQL string interpolation on the query param = SQL injection
  (a model that writes `where("priority = '#{params[:priority]}'")` fails the
  quality bar even if the test passes).
