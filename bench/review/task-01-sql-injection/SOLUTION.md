# Solution: Review Task 01 — SQL injection (ANSWER KEY, for the human judge only)

## The planted bug

**SQL injection** in `TodosController#index`:

```ruby
@todos = Todo.where("title LIKE '%#{params[:q]}%'").ordered
```

`params[:q]` is user-controlled and is **interpolated directly into the SQL
string** (double-quotes + `#{}`), not parameterized. A user can submit a `q`
value containing SQL metacharacters to break out of the `LIKE` clause and
execute arbitrary SQL (e.g. `' OR 1=1 --` returns all rows; worse, on
PostgreSQL `'); DROP TABLE todos; --` or `UNION SELECT ...` attacks are
possible depending on the adapter's multi-statement handling).

## The clean fix

Use a parameterized query / placeholder:

```ruby
@todos = Todo.where("title LIKE ?", "%#{params[:q]}%").ordered
```

Or use the Arel/sanitized form. The key is that ActiveRecord binds the value
as a parameter, so it can never be parsed as SQL.

## Scoring the model's review

- ✅ **Pass**: identifies SQL injection and points at the string
  interpolation of `params[:q]` into the query. Bonus if it shows the
  parameterized fix.
- ⚠️ **Partial**: mentions "query is unsafe" or "use parameterization"
  vaguely without pinning the exact line/mechanism.
- ❌ **Fail**: misses the vulnerability entirely, or only flags style issues
  (search form naming, etc.).

## Secondary observations a strong reviewer might also note (not required)

- `LIKE` is case-sensitive on PostgreSQL by default (`ILIKE` is usually
  intended for search). Not a bug, but a UX gotcha.
- No empty-result handling — fine for this app.
