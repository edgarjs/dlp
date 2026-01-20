# Requirements Phase

Transform a vague idea into clear, actionable requirements. This phase bridges the gap between what someone wants and what will actually be built.

## Purpose

Requirements work answers the question: "What problem are we solving, and how will we know when it is solved?"

Without clear requirements:
- Development targets shift constantly
- "Done" is undefined and debatable
- Effort is wasted on unwanted features
- Important needs are discovered too late

## Inputs and Outputs

**Inputs:**
- User request, problem statement, or feature idea
- Existing system context (if enhancing or modifying)
- Constraints (time, technology, resources)

**Outputs:**
- Validated specification ready for design phase
- Clear acceptance criteria for each requirement
- Documented scope boundaries

## Contents

| Document                             | Purpose                                                                  |
| ------------------------------------ | ------------------------------------------------------------------------ |
| [gathering.md](gathering.md)         | Extracting requirements from sources through questions and analysis      |
| [analysis.md](analysis.md)           | Processing gathered information to identify implicit needs and conflicts |
| [user-stories.md](user-stories.md)   | Writing effective user stories and organizing them with story mapping    |
| [specification.md](specification.md) | Writing formal, testable requirement statements                          |
| [validation.md](validation.md)       | Confirming requirements are complete and approved                        |

## Reading Order

Work through these documents sequentially:

1. **gathering.md** — Collect raw information
2. **analysis.md** — Process and refine what you collected
3. **user-stories.md** — Capture requirements as user stories
4. **specification.md** — Formalize into precise statements
5. **validation.md** — Verify completeness and get approval

## Workflow

```mermaid
flowchart LR
    A[Raw Input] --> B[Gathering]
    B --> C[Analysis]
    C --> D[User Stories]
    D --> E[Specification]
    E --> F[Validation]
    F -->|Gaps found| B
    F -->|Approved| G[Ready for Design]
```

The process is iterative. Validation often reveals gaps that require returning to earlier steps.

## Key Principles

- **Ask before assuming** — Ambiguity resolved through questions is cheaper than ambiguity resolved through rework
- **Document the negative** — What is explicitly out of scope is as important as what is in scope
- **Testability is non-negotiable** — If you cannot describe how to verify a requirement, it is not ready
- **Stakeholder alignment matters** — Technical correctness means nothing if it does not solve the actual problem

## When to Proceed to Design

Move to the design phase when:

- All requirements have clear acceptance criteria
- Scope boundaries are documented and agreed upon
- Stakeholders have reviewed and approved the specification
- No known ambiguities remain unresolved
- You could explain to someone else exactly what "done" means

If any of these are uncertain, continue requirements work.
