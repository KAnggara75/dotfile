# AGENTS.md — AI Workspace Guidelines & Quick Reference

Welcome to the **dotfile** repository. This document serves as the high-level entry point, operational constraints, and coding standards for all AI pair-programmers and autonomous agents.

Detailed baseline architectural documents reside inside the [`.context/`](file:///.context) directory.

---

## 1. Grounded Context & System Memory

Before planning or executing non-trivial modifications, consult the baseline documentation in `.context/`:
- [`.context/CODEBASE_MAP.md`](file:///.context/CODEBASE_MAP.md) — Subsystem layout, file responsibilities, and consumers.
- [`.context/ARCHITECTURE.md`](file:///.context/ARCHITECTURE.md) — Shell lifecycle flow, multiplexer passthrough, and telemetry.
- [`.context/PROJECT_CONTEXT.md`](file:///.context/PROJECT_CONTEXT.md) — High-level purpose, domain glossary, and boundaries.
- [`.context/DECISIONS.md`](file:///.context/DECISIONS.md) — Architecture Decision Records (ADRs, append-only).
- [`.context/TODO.md`](file:///.context/TODO.md) — Active technical debt and immediate improvement items.

---

## 2. Core Workspace Rules & Guidelines

### Security & Privacy First
- **Zero Secrets in Git**: Never stage or commit tokens, private keys (`id_rsa`, `id_ed25519`), IP addresses, or credentials.
- **Local Secret Boundary**: All corporate access tokens, private keys, and sensitive environment variables MUST reside solely in `~/.zshrc.secret` (or `.zshrc.secret` in the repo root), which is strictly ignored by `.gitignore`.
- **Pre-commit Gate**: `.githooks/pre-commit` enforces regex inspection on high-entropy secrets and blocked file types.

### Shell & Execution Safety
- **Zsh Variable Scope**: Never declare `local path` inside Zsh shell functions. In Zsh, the scalar environment variable `PATH` is tied automatically to the array `path`. Overwriting `local path` breaks command resolution (use `local target_path` instead).
- **Zsh Function vs Alias**: When transforming an alias to a function in `.zshrc`, always precede the function declaration with `unalias <name> 2>/dev/null` to prevent Zsh alias expansion parse errors.
- **Idempotency & Dry-Run Standard**: Helper scripts inside `setup/` and `swap.sh` MUST support `-n` / `--dry-run` and check preconditions (e.g. installed tools, existing files) before applying state changes.
- **Syntax Check Gate**: All shell scripts must pass `zsh -n` and `shellcheck`. `.githooks/pre-commit` automatically verifies this locally before any commit is accepted.

---

## 3. Delivery & Commit Standards

- **Conventional Commits**: Always format commit messages with semantic types (`feat`, `fix`, `refactor`, `docs`, `chore`, `style`, `test`, `ci`, `perf`).
- **Atomic Commits**: Group related changes cleanly or use file-by-file commits when appropriate.
- **Skill Utilization**: Use available workspace skills (e.g., `ka-git-commit`, `ka-context`, `ka-review`) where applicable.
