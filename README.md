# Development Lifecycle Protocol (DLP)

A structured guide for building software. This protocol covers the software development lifecycle from requirements through testing, providing actionable checklists, decision trees, and guidance for each phase.

## What This Is

This collection of Markdown documents provides:

- **Checklists** — Step-by-step guidance for common tasks
- **Decision trees** — Flowcharts for choosing appropriate approaches
- **Principles** — Core concepts that inform decisions throughout
- **Patterns** — Proven solutions to recurring problems

The protocol is designed for LLM agents and human developers alike. It maintains a purely Markdown-based structure with pseudocode examples and Mermaid diagrams—no executable code.

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

1. Start with `foundations/` to understand core principles and document format
2. Follow phases in order: requirements → design → development → testing
3. Reference `concerns/` throughout—these apply to all phases
4. Each folder has a README.md with reading order and context
5. Cross-references link related concepts—follow them as needed

## Structure

```
.dlp/
├── foundations/       Core principles and meta-guidance
│   ├── principles.md        Software development principles
│   ├── terminology.md       Glossary of terms
│   ├── document-format.md   How to read this protocol
│   └── decision-making.md   Framework for making choices
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
    ├── api-contract.yml               OpenAPI 3.1 specification template
    └── test-strategy.md               Test strategy template
```

## Scope

This protocol covers:

- Requirements gathering through validation
- System design and architecture
- Implementation practices and patterns
- Testing strategy and execution
- Security as a cross-cutting concern

This protocol does not cover:

- Project management and planning
- Deployment and operations
- Team organization
- Specific technologies or frameworks
