# Solution: Task 02 — Notes association (ANSWER KEY, for the human judge only)

## A clean implementation

**Migration** (`db/migrate/<ts>_create_notes.rb`):
```ruby
class CreateNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :notes do |t|
      t.references :todo, null: false, foreign_key: true
      t.text :body, null: false
      t.timestamps
    end
  end
end
```

**Model** (`app/models/note.rb`):
```ruby
class Note < ApplicationRecord
  belongs_to :todo
  validates :body, presence: true
end
```

**Association** (`app/models/todo.rb`):
```ruby
has_many :notes, dependent: :destroy
```

**Route** (`config/routes.rb`):
```ruby
resources :todos do
  member { patch :toggle }
  resources :notes, only: [:create]
end
```

**Controller** (`app/controllers/notes_controller.rb`):
```ruby
class NotesController < ApplicationController
  def create
    @todo = Todo.find(params.expect(:todo_id))
    @note = @todo.notes.new(note_params)
    if @note.save
      redirect_to @todo, notice: "Note was successfully added."
    else
      redirect_to @todo, status: :unprocessable_content, alert: "Note could not be saved."
    end
  end

  private
    def note_params
      params.expect(note: [:body])
    end
end
```

**View** (`app/views/todos/show.html.erb`) — list notes + form:
```erb
<h2>Notes</h2>
<div id="notes">
  <% @todo.notes.each do |note| %>
    <div id="<%= dom_id note %>"><%= note.body %></div>
  <% end %>
</div>

<%= form_with(model: [@todo, Note.new], url: todo_notes_path(@todo)) do |form| %>
  <%= form.text_area :body %>
  <%= form.submit "Add note" %>
<% end %>
```

## What to look for

- ✅ All three tests pass.
- ✅ `belongs_to :todo` + `has_many :notes` with `dependent: :destroy`.
- ✅ `body` validates presence (the blank-body test fails without this).
- ✅ `null: false` on the migration's `body` column.
- ✅ Strong params on the note controller (`params.expect(note: [:body])`).
- ✅ `dom_id` used for note elements.
- ❌ Validation skipped = third test fails.
- ❌ `Note.create!` without validation handling = 500 on blank body instead of redirect.
