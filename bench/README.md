# Factory Model Benchmark

Compare LLM models head-to-head on realistic Ruby on Rails work, specific to
the factory's roles (worker, reviewer, coordinator). Designed to be re-run
whenever a new model lands or an existing one gets a weights update.

## Why

Public leaderboards (SWE-bench, artificialanalysis) are useful but generic.
They run on Python codebases and tasks that may be partially memorized. This
benchmark runs on **our** stack (Rails 8.1, PostgreSQL, Minitest) with tasks
shaped like the feature work the factory actually does. The signal is
relative — does model A produce better Rails code / catch more bugs than
model B — not an absolute score.

## The three axes (map to factory roles)

| Axis | Tests | Role | Round |
|------|-------|------|-------|
| **Coding** | Implement a feature from a spec; a failing test defines acceptance | worker | 1 |
| **Review** | Review a PR with a planted bug; find the bug + explain it | reviewer | 1 |
| **Agentic** | Multi-part task with subagent delegation available | coordinator | 2 (deferred) |

Round 1 = Coding + Review only. Agentic is deferred until Round 1 proves the
tasks differentiate models. If two models tie on simple coding tasks, a
complex agentic task won't separate them either; harden the tasks first.

## How a run works

Every task is **one GitHub issue** (labeled `benchmark-coding` /
`benchmark-review`). The issue body is the spec. The repo carries the
acceptance test (coding) or planted bug (review) under `bench/`.

### Running a coding task

```bash
# from a fresh clone on the VM or Mac
git checkout main && git pull
git checkout -b bench/coding/task-01/<model-slug>   # e.g. bench/coding/task-01/glm-5.2

# copy the acceptance test into place (it will FAIL — that's expected)
cp bench/coding/task-01-priority-filter/test.rb test/integration/priority_filter_test.rb

# run the model (bare session — no factory, no coordinator)
pi -p --model litellm/glm-5.2:high "$(cat bench/coding/task-01-priority-filter/SPEC.md)"

# verify
bin/rails test test/integration/priority_filter_test.rb
```

The model reads the spec, implements until the test passes, and commits. The
branch IS the artifact — push it to compare diffs side-by-side on GitHub.

### Running a review task

```bash
git checkout main && git pull
pi -p --model litellm/glm-5.2:high "$(cat bench/review/task-01-sql-injection/SPEC.md)"
```

The spec contains the PR diff inline. The model reviews it and reports
findings. Output is the model's review text (no code changes expected).

## What we record (manually, on the issue)

After each run, post a comment on the task's issue with:

```
## Run: <model> — <date>

- Model: litellm/glm-5.2 (thinking: high)
- Wallclock: 4m 12s
- Tokens: 142K prompt / 8K completion (from LiteLLM /sessions or /spend)
- Cache hit: 97%
- Cost: $0.03 (LiteLLM spend)
- Test pass: YES / NO
- Branch: bench/coding/task-01/glm-5.2
- Notes: <one or two sentences of qualitative observation>
```

The issue becomes the longitudinal record — re-run with a new model, add
another comment below the old ones.

## The judgment

Pass/fail is the headline (test green / bug found). But pass/fail alone is
too binary on easy tasks. The human (you) reads the diff or review output and
judges code quality / review reasoning. The LiteLLM numbers (tokens, $,
wallclock) add the efficiency axis. Together: **capability × efficiency**.

## Models under test (Round 1, initial)

- `litellm/deepseek-v4-flash` — current factory worker (cheap, fast)
- `litellm/glm-5.2` — reasoning model (Neuralwatt, standard tier)

A third model (deepseek-v4-pro, kimi-k2.6) joins only if Round 1 differentiates
the first two and harder data is wanted.

## Keeping runs fair (isolate the model from answer keys)

The model is given **only the SPEC.md** as its prompt (fed via `$(cat SPEC.md)`),
never the `SOLUTION.md`. For coding tasks the model runs inside the repo on
main, so it *could* `cat bench/coding/*/SOLUTION.md` — a well-behaved model
focused on the spec won't, and you'd see it in the transcript if it did. If
you want to be strict, strip the answer keys from the worktree before the run:

```bash
rm -f bench/coding/*/SOLUTION.md bench/review/*/SOLUTION.md
```

The review tasks pass the model only the SPEC.md text (which embeds the diff),
so the model never touches `bench/` at all during a review run.

## Repo conventions

- Main stays **green** — acceptance tests live under `bench/`, NOT in `test/`,
  so `bin/rails test` on `main` is unaffected. A run copies the test into
  `test/` on its own branch.
- Bug branches for review tasks live under `bench/review-*` and are
  frozen — never rebase them once a run has been scored against them.
- One directory per task: `bench/coding/task-NN-<slug>/` with `SPEC.md`,
  `test.rb` (coding), `bug.patch` (review), `SOLUTION.md` (the answer key,
  for the human judge only — do NOT feed to the model).
