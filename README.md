# Development Lifecycle Protocol (DLP)

A structured guide for building software with LLM agents. This protocol covers the software development lifecycle from requirements through testing, providing actionable checklists, decision trees, and guidance for each phase.

---

## What This Is

This collection of Markdown documents provides:

- **Checklists** — Step-by-step verification for common tasks
- **Decision trees** — Mermaid flowcharts for choosing approaches
- **Principles** — Core concepts that inform decisions
- **Templates** — Ready-to-use formats for output artifacts

The protocol is designed for LLM agents and humans alike. It maintains a purely Markdown-based structure with pseudocode examples and Mermaid diagrams—no executable code.

## Installation

Run this command inside your project's root directory:

```bash
curl -sSL https://github.com/edgarjs/dlp/raw/main/install.sh | bash
```

This will install the DLP at `$HOME/.dlp` and create or modify the `AGENTS.md`, `CLAUDE.md` and `GEMINI.md` files of your project, to reference the DLP installation at your home directory.

If you prefer to keep a copy of the DLP at the project level, you can use the `--local` flag:

```bash
curl -sSL https://github.com/edgarjs/dlp/raw/main/install.sh | bash -s -- --local
```

This creates `.dlp/` in your project and updates agents files automatically.

## How to Use This Protocol

**For LLM agents:** Start with `AGENTS.md` for mandatory instructions, then follow the phase sequence.

**For humans:** Start with `foundations/` to understand principles, then follow phases in order.

**For both:**

1. **Choose a work path** — Use Standard Path for features/significant changes, Minimal Path for small bug fixes
2. Follow phases in order: requirements → design → development → testing (Standard Path)
3. Reference `concerns/` throughout—these apply to all phases
4. Each folder has a `README.md` with reading order and context
5. Use `templates/` for consistent output artifacts

### Work Paths

Not all work requires full ceremony. The DLP supports two paths:

| Path     | When to Use                      | What's Required                           |
| -------- | -------------------------------- | ----------------------------------------- |
| Standard | Features, significant changes    | All four phases, full documentation       |
| Minimal  | Small bug fixes, trivial changes | Fix → Test → Commit (no design artifacts) |

See `foundations/work-paths.md` for qualification criteria and workflow details.

## Structure

```
.dlp/
├── foundations/       Core principles and meta-guidance
│   ├── principles.md        Software development principles
│   ├── terminology.md       Glossary of terms
│   ├── decision-making.md   Framework for making choices
│   └── work-paths.md        Standard vs. Minimal work paths
│
├── requirements/      Gathering, analyzing, specifying requirements
│   ├── gathering.md         Extracting requirements from sources
│   ├── analysis.md          Processing and refining requirements
│   ├── user-stories.md      Writing effective user stories
│   ├── specification.md     Writing formal requirements
│   └── validation.md        Confirming requirements are complete
│
├── design/            Architecture, data modeling, interface contracts
│   ├── exploration.md       Evaluating approaches
│   ├── architecture.md      High-level system structure
│   ├── data-modeling.md     Designing data structures
│   ├── api-contracts.md     Defining interfaces and contracts
│   └── design-review.md     Validating the design
│
├── development/       Coding standards, patterns, workflow, review
│   ├── setup.md             Environment and project setup
│   ├── coding-standards.md  Conventions for consistent code
│   ├── patterns.md          Common solutions to problems
│   ├── error-handling.md    Dealing with failures
│   ├── dependency-management.md  Evaluating and updating dependencies
│   ├── git-workflow.md      Version control practices
│   ├── implementation-workflow.md  The coding process
│   └── code-review.md       Reviewing implementations
│
├── testing/           Strategy, unit tests, integration tests, maintenance
│   ├── test-strategy.md     Planning what to test
│   ├── testing-practices.md Unit and integration testing
│   ├── test-design.md       Writing effective tests
│   ├── test-automation.md   CI integration, test infrastructure
│   └── test-maintenance.md  Keeping tests healthy
│
├── concerns/          Cross-cutting concerns (apply to all phases)
│   ├── security.md          Protecting systems from threats
│   ├── performance.md       Optimizing efficiency and responsiveness
│   ├── accessibility.md     Ensuring usability for all users
│   └── observability.md     Understanding system state through monitoring
│
└── templates/         Ready-to-use templates for output artifacts
    ├── requirements-specification.md  Requirements document template
    ├── user-stories.md                User stories template
    ├── design-decision.md             Design decision record template
    ├── architecture.md                Architecture document template
    ├── data-model.md                  Data model template
    └── api-contract.yml               OpenAPI 3.1 specification template
```

## Scope

**Covered:**

- Requirements gathering through validation
- System design and architecture
- Implementation practices and patterns
- Testing strategy and execution
- Cross-cutting concerns (security, performance, accessibility, observability)

**Not covered:**

- Project management and planning
- Deployment and operations
- Team organization
- Specific technologies or frameworks
