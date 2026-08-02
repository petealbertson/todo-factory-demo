# Solution: Review Task 02 — XSS (ANSWER KEY, for the human judge only)

## The planted bug

**Cross-site scripting (XSS)** in `app/views/todos/show.html.erb`:

```erb
<%= @todo.description.html_safe %>
```

`description` is user-supplied text persisted from the todo form. Calling
`.html_safe` on it tells Rails "this string is safe, don't escape it" — so
any HTML, including `<script>...</script>`, stored in a todo's description
will be rendered and executed in every visitor's browser. Since the todo
form is open (no auth in this app), any user can plant a stored-XSS payload
that fires for everyone who views that todo.

## The clean fix

Either let Rails auto-escape (just `<%= @todo.description %>`) if plain
text is acceptable:

```erb
<%= @todo.description %>
```

Or, if genuine HTML formatting is the intent, sanitize explicitly with an
allowlist:

```erb
<%= sanitize @todo.description %>
```

`.html_safe` should **never** be called on user-controlled input.

## Scoring the model's review

- ✅ **Pass**: identifies the XSS via `.html_safe` on user-provided
  `description`, and explains the stored-XSS consequence. Bonus for the
  sanitize/auto-escape fix.
- ⚠️ **Partial**: flags `.html_safe` as "risky" without explaining it's
  user input that makes it an XSS.
- ❌ **Fail**: misses it, or only comments on the migration
  (e.g. "should add an index" — true but not the bug).

## Secondary observations a strong reviewer might also note (not required)

- The migration adds a nullable `:text` column with no default — acceptable,
  but a `null: false, default: ""` would be more disciplined.
- No index needed for a description column.
