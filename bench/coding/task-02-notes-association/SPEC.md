# Task: Add notes to todos

## Context

This is a Rails 8.1 todo app. A `Todo` (`title`, `completed`, `due_date`,
`priority`) is shown at `GET /todos/:id` via `TodosController#show` and
`app/views/todos/show.html.erb`.

## Requirement

Add a **Note** model associated with a todo (`Todo has_many :notes`). A note
has a single `body` (text) field. Users should be able to:

1. Add a note to a todo from the todo's show page.
2. See all notes for a todo listed on its show page.

Each note should render with its own DOM id (`dom_id`) so the acceptance test
can count them.

## Acceptance test

A test file is provided at `bench/coding/task-02-notes-association/test.rb`.
Copy it into `test/integration/todo_notes_test.rb` and implement the feature
so `bin/rails test test/integration/todo_notes_test.rb` passes. Do not modify
the test file.

Create the migration, model, route, controller, and views needed.

## Out of scope

- No authentication or users; the note just belongs to a todo.
- No editing or deleting notes (create + display only).
- No nested attributes form; a separate note form on the show page is fine.
