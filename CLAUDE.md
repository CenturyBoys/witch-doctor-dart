# CLAUDE.md

Guidance for Claude Code (claude.ai/code) in this repository.

**Read [`AGENTS.md`](AGENTS.md) first — it is the canonical guide** for project
overview, repository layout, commands, architecture, and the hard contribution
rules (GitFlow, Conventional Commits, and the no-AI-co-author policy). This file
only adds Claude-specific notes.

## Claude-specific notes

- This is a **pub workspace** (monorepo). Run `dart pub get` / `dart analyze`
  from the root; run `dart test` inside `packages/witch_doctor`; run
  `dart run build_runner build` inside `packages/witch_doctor/example`.
- **Do not add `Co-Authored-By:` trailers or any AI attribution** to commits or
  PRs in this repo (see AGENTS.md → Commit authorship).
- Follow **GitFlow** strictly: feature branches from `develop`, hotfixes from
  `main`. Never commit to `main`/`develop` directly.
- Use **Conventional Commits** for every commit message.
- Keep the runtime package (`witch_doctor`) dependency-free; code-generation
  deps belong to `witch_doctor_generator`.
