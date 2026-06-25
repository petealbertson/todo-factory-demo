# todo-factory-demo

Minimal Rails 8.1 app used to exercise the cloud factory (see `petealbertson/factory-config`).

## Stack
- Ruby 3.4, Rails 8.1, PostgreSQL
- Standard scaffold: `Todo` model (title:string, completed:boolean), full CRUD at `/todos`.

## Commands
- `bin/rails test` (system/request tests)
- `bundle exec standardrb` (lint, if present)
- `bin/rails db:migrate` then `bin/rails db:seed`

## Notes for factory agents
- `config/database.yml` is worktree-aware: each working directory resolves to its own DB. The factory runner creates these from a template; do not edit DB config.
- Validation: run `bin/rails test` (and `bundle exec standardrb` if installed) before pushing.
