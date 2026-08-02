# Task: Filter todos by priority

## Context

This is a Rails 8.1 todo app. A `Todo` has a `priority` enum (`low`, `medium`,
`high`, default `medium`). The list of todos lives at `GET /todos` and is
rendered from `TodosController#index` using `app/views/todos/index.html.erb`
and the `app/views/todos/_todo.html.erb` partial. Each todo partial renders a
root `<div id="<%= dom_id todo %>">` (i.e. `id="todo_42"`).

## Requirement

Add the ability to **filter the todos list by priority** via a query
parameter. Visiting `/todos?priority=high` should show only the high-priority
todos. Visiting `/todos` (no param) shows all todos as before.

Add filter links on the index page so a user can click "High", "Medium",
"Low", and "All" to filter the list.

## Acceptance test

A test file is provided at `bench/coding/task-01-priority-filter/test.rb`.
Copy it into `test/integration/priority_filter_test.rb` and implement the
feature so `bin/rails test test/integration/priority_filter_test.rb` passes.
Do not modify the test file.

Make all code changes (model scope, controller, view) needed to satisfy it.
Follow the conventions already in the app.

## Out of scope

- No authentication or users exist in this app; don't add any.
- Don't change the `ordered` scope behavior except to compose with filtering.
- JavaScript / Turbo is not required.
