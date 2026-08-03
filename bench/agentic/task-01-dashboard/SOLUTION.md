# Solution: Agentic task — Dashboard (ANSWER KEY, for the human judge only)

## Reference implementation

### Deliverable A — Stats

**Model method** (`app/models/todo.rb`):
```ruby
def self.stats
  {
    total:     count,
    completed: where(completed: true).count,
    overdue:   where("due_date IS NOT NULL AND due_date < ? AND completed = ?", Date.current, false).count
  }
end
```
(Or a `TodoStats` service object. Either is fine — a class method on `Todo`
is the lighter-touch Rails convention.)

**Controller** (`app/controllers/stats_controller.rb`):
```ruby
class StatsController < ApplicationController
  def show
    render json: Todo.stats
  end
end
```

**Route**: `get "stats" => "stats#show"` (or `resource :stats, only: :show`).

### Deliverable B — Tags

**Migration** (`db/migrate/<ts>_create_tags.rb`):
```ruby
class CreateTags < ActiveRecord::Migration[8.1]
  def change
    create_table :tags do |t|
      t.references :todo, null: false, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end
  end
end
```

**Model** (`app/models/tag.rb`):
```ruby
class Tag < ApplicationRecord
  belongs_to :todo
  validates :name, presence: true
end
```

**Association** (`app/models/todo.rb`): `has_many :tags, dependent: :destroy`

**Partial** (`app/views/todos/_todo.html.erb`) — add inside the existing div:
```erb
<% if todo.tags.any? %>
  <div class="tags">
    <% todo.tags.each do |tag| %>
      <span class="tag"><%= tag.name %></span>
    <% end %>
  </div>
<% end %>
```

### Deliverable C — Dashboard

**Controller** (`app/controllers/dashboards_controller.rb`):
```ruby
class DashboardsController < ApplicationController
  def show
    @stats = Todo.stats
    @todos = Todo.ordered
  end
end
```

**View** (`app/views/dashboards/show.html.erb`):
```erb
<h1>Dashboard</h1>

<section class="stats">
  <p>Total: <%= @stats[:total] %></p>
  <p>Completed: <%= @stats[:completed] %></p>
  <p>Overdue: <%= @stats[:overdue] %></p>
</section>

<div id="todos">
  <%= render @todos %>
</div>
```

**Route**: `get "dashboard" => "dashboards#show"` (or `resource :dashboard, only: :show`).

## Shared-file collision risk (the agentic part)

All three deliverables add lines to `config/routes.rb`. A and B each add a
line to `app/models/todo.rb` (A: `def self.stats`; B: `has_many :tags`). A
coordinator that fans A and B out to parallel workers in the same working
directory risks:
- both workers editing `routes.rb` at once → one overwrites the other,
- both workers editing `todo.rb` → same.

**Strong coordinator behavior:**
- Recognizes A+B+C dependency (C needs A+B).
- Parallelizes A and B but uses git worktrees (`worktree: true`) OR sequences
  the shared-file edits (does routes.rb itself after workers finish), OR
  runs A and B serially to avoid the collision.
- Verifies integration (C's test) after delegating A and B.

**Weak coordinator behavior:**
- Does everything sequentially itself (no delegation) → passes but wastes the
  subagent capability (not agentic).
- Fans out A+B in parallel without isolation → conflicts, broken state,
  recovery loops (this is the glm-5.2 task-02 risk pattern).
- Delegates without realizing C depends on A+B → tries C before A/B done.

## Scoring the coordinator

- **Headline:** all 3 tests pass.
- **Agentic quality (the real signal):**
  - Did it use the subagent tool at all? (0 calls = not agentic)
  - Did it parallelize, and did it handle the routes.rb/todo.rb collision?
  - Did it sequence C after A+B, or attempt C prematurely?
  - Total tool calls / tokens / wallclock (efficiency).
  - Did it require self-recovery (re-running after a broken state)?
- Compare to the coding-axis runs: a coordinator should NOT hand-write every
  file — it should delegate. If a model achieves pass with 0 subagent calls,
  that's a coordinator red flag even though the test is green.
