# Task: Build a todo dashboard

## Context

This is a Rails 8.1 todo app. A `Todo` has `title`, `completed` (boolean),
`due_date` (date, nullable), and `priority` (enum: low/medium/high, default
medium). The model already has an `overdue?` method (true when `due_date` is in
the past and not completed) and an `ordered` scope. Todos render via the
`app/views/todos/_todo.html.erb` partial.

There are **no** tags, stats, or dashboard yet. You are building three new
things and wiring them together.

## The three deliverables

### A. Stats JSON endpoint

`GET /stats.json` returns a JSON object with exactly these top-level keys:

```json
{ "total": 3, "completed": 1, "overdue": 1 }
```

- `total` — count of all todos.
- `completed` — count where `completed` is true.
- `overdue` — count where `overdue?` is true.

### B. Tags

Add a `Tag` model (`name:string`) so that `Todo has_many :tags` and a tag
belongs to a todo. Render each tag in the todo partial as
`<span class="tag">name</span>`, so tags appear wherever a todo is rendered
(index, show, dashboard). A todo form field for entering tags is a nice-to-have
but not required by the acceptance test.

### C. Dashboard page (the integration)

`GET /dashboard` renders an HTML page that:
- Has an `<h1>` containing the word "Dashboard" (case-insensitive).
- Shows a stats summary derived from deliverable A (the word "total" must
  appear, alongside the count).
- Renders the list of todos (which, via the `_todo` partial, now shows their
  tags from deliverable B).

The dashboard **depends on A and B** — you can't satisfy its test without both
done. Plan accordingly.

## Acceptance test

A test file is provided at `bench/agentic/task-01-dashboard/test.rb`. Copy it
to `test/integration/dashboard_benchmark_test.rb` and implement all three
deliverables so `bin/rails test test/integration/dashboard_benchmark_test.rb`
passes. Do not modify the test file.

## On delegation

You have access to the **subagent** tool and can delegate implementation work
to a `worker` subagent (or several in parallel). How you decompose and
schedule the work — do it all yourself, delegate selectively, or fan out — is
up to you. The three deliverables touch mostly disjoint files, but note that
several of them add lines to `config/routes.rb` and `app/models/todo.rb`, so
if you parallelize, think about where shared-file edits will land. A
sequential approach is also fine; the choice is yours.

Do not modify the acceptance test, `bench/`, or `test/fixtures/`. Create all
migrations, models, controllers, routes, and views you need.
