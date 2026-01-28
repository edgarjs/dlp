# Foundations

This folder contains the core concepts and meta-guidance that underpin the entire development protocol. These documents establish shared vocabulary, principles, and frameworks that are referenced throughout all subsequent phases.

---

## Quick Reference

| Document                                 | Purpose                                | Read When                                   |
| ---------------------------------------- | -------------------------------------- | ------------------------------------------- |
| [terminology.md](terminology.md)         | Glossary of terms                      | A term is unclear or used unexpectedly      |
| [principles.md](principles.md)           | Core development principles            | Making design or implementation decisions   |
| [document-format.md](document-format.md) | How to read checklists, decision trees | First time using the protocol               |
| [decision-making.md](decision-making.md) | Framework for choices                  | Facing trade-offs or conflicting principles |
| [work-paths.md](work-paths.md)           | Standard vs. Minimal paths             | Determining ceremony level for a task       |

---

## Purpose

Before diving into specific phases like requirements gathering or implementation, you need a common foundation:

- **Shared language** — Terms mean the same thing everywhere in this protocol
- **Guiding principles** — Core beliefs that inform every decision
- **Document literacy** — How to read and execute the protocol itself
- **Decision frameworks** — How to make choices when facing trade-offs

## Contents

| Document                                 | Purpose                                                                                      |
| ---------------------------------------- | -------------------------------------------------------------------------------------------- |
| [principles.md](principles.md)           | Core software development principles with guidance on when to apply and when to violate them |
| [terminology.md](terminology.md)         | Glossary of terms used throughout the protocol                                               |
| [document-format.md](document-format.md) | How to interpret checklists, decision trees, and templates in this protocol                  |
| [decision-making.md](decision-making.md) | Framework for making choices when multiple valid options exist                               |
| [work-paths.md](work-paths.md)           | Defines Standard and Minimal paths based on work scope and risk                              |

## Reading Order

Read these documents in sequence before proceeding to any phase:

1. **terminology.md** — Establishes the vocabulary
2. **principles.md** — Establishes the values
3. **document-format.md** — Teaches you how to use this protocol
4. **decision-making.md** — Prepares you for trade-off situations
5. **work-paths.md** — Determines appropriate ceremony level

## How to Use This Folder

**For LLM agents:**

1. Read these documents during your first session with the protocol
2. Reference `terminology.md` when encountering unfamiliar terms
3. Reference `principles.md` when making decisions
4. Reference `decision-making.md` when principles conflict
5. Reference `work-paths.md` to choose Standard or Minimal path for each task

**For humans:**

1. Read all four documents before starting any phase
2. Return to them as reference material throughout the project

---

## Key Principles Summary

For quick reference, the core principles are:

| Principle                        | Meaning                                                         |
| -------------------------------- | --------------------------------------------------------------- |
| **YAGNI**                        | Don't build functionality until actually needed                 |
| **KISS**                         | Prefer the simplest solution that works                         |
| **DRY**                          | Each piece of knowledge has one authoritative location          |
| **Separation of Concerns**       | Each component addresses one well-defined concern               |
| **Fail Fast, Fail Clearly**      | Detect and report errors early with clear messages              |
| **Composition over Inheritance** | Compose objects from smaller parts rather than deep hierarchies |
| **Law of Demeter**               | Only talk to immediate friends, not strangers                   |

See [principles.md](principles.md) for full explanations and when to apply or violate each.
