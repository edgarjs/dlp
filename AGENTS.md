# Agent Instructions

This document provides instructions for LLM agents working with the Development Lifecycle Protocol (DLP). For reliable compliance, use Claude Sonnet or better.

## Getting Started

Your first response to any task must begin with these three items:

1. **Choose a work path.** Use Minimal Path only if the task is a small bug fix where: the change is isolated, root cause is known, fix is obvious, risk is low, it's reversible, no interfaces change, and tests exist or are trivial to add. Otherwise use Standard Path. If the task is too ambiguous to choose, state "Path: Needs clarification" and list your questions — then complete steps 2 and 3 after the user responds.

2. **Find constraints.** Read the project's README, AGENTS.md, and docs directory for existing technology choices, architecture decisions, and coding standards. State what you found (or "no constraints found").

3. **State your starting phase.** Standard Path starts at REQUIREMENTS. Minimal Path starts at DEVELOPMENT.

Example — your response should start like this:

> **Path:** Standard — this is a new feature requiring design decisions.
> **Constraints:** Project uses TypeScript, Express, and Prisma (from README.md).
> **Phase:** REQUIREMENTS
>
> Before I proceed, a few questions:
> - **Docs path:** Where should I save artifacts? (default: `docs/`)
> - **Autonomy:** Should I work autonomously or pause for review at each phase?
> - [any task-specific clarifying questions]

Always include the Path/Constraints/Phase block first, even if you also need to ask questions. Never skip the block to jump straight to questions.

---

## Phases

The DLP has four sequential phases. Work through them in order:

| Phase        | README Path              | Purpose                              |
| ------------ | ------------------------ | ------------------------------------ |
| REQUIREMENTS | `requirements/README.md` | Define what to build                 |
| DESIGN       | `design/README.md`       | Define how to structure the solution |
| DEVELOPMENT  | `development/README.md`  | Build the solution                   |
| TESTING      | `testing/README.md`      | Verify the solution works            |

**Cross-cutting concerns** in `concerns/` (security, performance, accessibility, observability) apply to ALL phases.

### Reading Order Within Each Phase

1. Read the phase's `README.md` first
2. Follow the reading order specified in that README
3. Reference `concerns/` for cross-cutting considerations
4. Use `templates/` for output artifacts

---

## Minimal Path

When using Minimal Path, state your qualification:

> **Minimal Path Qualification:**
> - Isolated: [component/file]
> - Root cause: [brief]
> - Fix: [one line]
> - Risk: Low — [why]
> - Reversible: Yes
> - Interfaces: No changes
> - Tests: [existing/will add]

If at any point the criteria stop applying, escalate to Standard Path and state why.

---

## Artifacts and Templates

Generate documentation artifacts BEFORE generating code. Use templates from `templates/`:

| Artifact Type         | Template                                  | Phase        |
| --------------------- | ----------------------------------------- | ------------ |
| Requirements Document | `templates/requirements-specification.md` | REQUIREMENTS |
| User Stories          | `templates/user-stories.md`               | REQUIREMENTS |
| Design Decisions      | `templates/design-decision.md`            | DESIGN       |
| Architecture          | `templates/architecture.md`               | DESIGN       |
| Data Models           | `templates/data-model.md`                 | DESIGN       |
| API Contracts         | `templates/api-contract.yml`              | DESIGN       |

---

## Phase Transitions

Each phase has exit criteria. Do not proceed until all are met:

**REQUIREMENTS → DESIGN:**

- [ ] All requirements have clear acceptance criteria
- [ ] Scope boundaries are documented
- [ ] Stakeholders have reviewed and approved
- [ ] No unresolved ambiguities

**DESIGN → DEVELOPMENT:**

- [ ] Architecture addresses all requirements
- [ ] Data models support all use cases
- [ ] Interfaces between components are defined
- [ ] Design has been reviewed and approved
- [ ] Documentation is updated

**DEVELOPMENT → TESTING:**

- [ ] Implementation is complete per design
- [ ] Code review is approved
- [ ] Code passes automated checks
- [ ] No known issues remain unaddressed

**TESTING → COMPLETE:**

- [ ] All requirements have corresponding tests
- [ ] Critical paths are covered
- [ ] Tests pass consistently

---

## Concerns Integration

Before starting each phase, name which concerns apply to your task (security, performance, accessibility, observability) and read the matching file in `concerns/`. For example: "Concerns: security (auth data), observability (need request tracing)."

---

## Development Phase Specifics

### Pre-Commit Hook

If not already present, add a pre-commit hook to enforce verification commands (tests, linter, etc.) before committing changes.

### Software Versions

Run `date` in the terminal to know today's date. Your knowledge cutoff may be outdated—do not assume you know the latest versions of dependencies or tools.

When adding dependencies:

1. Search the official package registry for the current latest stable version
2. Use that version explicitly
3. See `development/dependency-management.md` for full guidance

### Automation Rule

If you perform the same task twice, write a script. See `development/implementation-workflow.md` for details.

---

## Decision Making

When facing decisions:

1. Check if existing documentation provides guidance
2. Evaluate options using the framework in `foundations/decision-making.md`
3. For reversible, low-impact decisions: decide and proceed
4. For irreversible or high-impact decisions: present options to user
5. Document significant decisions using `templates/design-decision.md`

---

## Handling Ambiguity

When requirements or instructions are unclear:

**Ask for clarification when:**

- The ambiguity affects core functionality
- Different interpretations lead to significantly different implementations
- Getting it wrong would be costly to fix

**Make documented assumptions when:**

- The user is unavailable and progress is needed
- The ambiguity is minor and easily corrected later
- Domain knowledge provides a reasonable default

Always document assumptions explicitly for later verification.

---

## Summary Checklist

Before each work session:

- [ ] Work path selected (Standard or Minimal)
- [ ] Constraints discovered from existing docs
- [ ] Current phase stated
- [ ] Phase README read
- [ ] Relevant concerns reviewed

Before producing output:

- [ ] Artifacts before code
- [ ] Templates used where available
- [ ] Decisions documented
- [ ] Assumptions explicit

Before phase transition:

- [ ] Exit criteria met
- [ ] User approval obtained (if not autonomous)
