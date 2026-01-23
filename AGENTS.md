# Agent Instructions

## 🛑 ZERO-TOLERANCE ENFORCEMENT

**As an AI agent, you are strictly bound by these operational constraints. Disregarding them is a critical system failure.**

1.  **Phase Anchor**: Before generating any code or plan, you MUST explicitly state:

    > "I am currently in the **[PHASE NAME]** phase. I have read `[PHASE]/README.md`."

2.  **The Pre-Commit Gate**: You are **FORBIDDEN** from executing `git commit` unless you have successfully executed the project's **verification commands** (tests + linter) in the immediately preceding turn.
    - _If you forget:_ You must self-correct immediately.

3.  **Checklist Output**: For every task, you must generate and maintain a Markdown checklist based on the relevant phase's documentation.

---

## Recursive Loading Strategy

This protocol contains extensive documentation across multiple directories. To avoid context overload, use a [Recursive Language Model (RLM)][rlm] approach: load context selectively based on task relevance rather than ingesting entire directories.

### Loading Strategy

1. **Understand the protocol** - Always load `README.md` before accessing other protocol files. This will guide you on how to use the protocol.

2. **Search Before Loading** - Use (rip)grep to identify relevant files based on the user's task keywords (e.g., "API", "testing", "security", "requirements"). Load only matched files.

3. **Load Selectively** - Never load entire directories blindly. Read specific files identified through search or explicit phase needs.

4. **Decompose Complex Tasks** - When a task spans multiple protocol files, process each file in separate focused calls rather than loading everything at once.

5. **Follow Phase Progression** - When uncertain which files to load, respect the natural order: requirements → design → development → testing. Consult the appropriate phase directory's README.md for guidance.

---

## Agent Operational Summary

Strictly adhere to these operational primitives:

1.  **Phase Locking**: Identify the user's current intent and map it to a specific directory (Phase). Do not skip phases (e.g., do not write code without a design contract).
2.  **Checklist Enforcement**: Every phase has a `README.md` or specific file with a **Checklist**. You must satisfy these items before declaring a task complete.
3.  **Artifact Precedence**: Generate the required Markdown artifacts (Specifications, Decisions, Contracts) _before_ generating executable code.
4.  **Concerns**: Always cross-reference `concerns/` (Security, Performance) when making design or implementation decisions.

---

## Task Execution Protocol

Before beginning work, establish workflow preferences and maintain protocol alignment:

### 1. Documentation Output Location

**Before generating any documentation artifacts**, ask the user:

> "Where would you like me to write documentation outputs (specifications, design docs, plans)?"

Common patterns:

- `docs/` directory
- `docs/plans/` for implementation plans
- `docs/specs/` for specifications
- `docs/design/` for design documents
- Project root for README updates

Document the preference and use it consistently throughout the session.

### 2. Autonomy Preference

**At the start of a multi-step task**, ask the user:

> "Would you prefer I work autonomously through all steps, or pause after each completed step for your review?"

**Autonomous mode:**

- Execute all planned steps sequentially
- Only stop for critical decisions or blockers
- Provide summary after completion

**Step-by-step mode:**

- Complete one logical step
- Report completion and results
- Wait for explicit approval before next step

Document the preference and follow it throughout the task.

### 3. Protocol Review Cycle

**Before starting each new major step** (moving between phases, starting a new feature, addressing new requirements):

1. Re-read the relevant DLP phase README
2. Review any protocol updates or new guidance
3. Update your plan if protocol insights reveal gaps or better approaches
4. Verify current step aligns with protocol best practices

```
Example workflow:
  Task: Implement user authentication

  Step 1: Requirements
    → Read requirements/README.md
    → Gather requirements using protocol guidance
    → Document in agreed location

  Step 2: Design
    → Re-read design/README.md (don't assume from memory)
    → Design data models, APIs per protocol
    → Update plan if design insights change approach
    → Document design

  Step 3: Implementation
    → Re-read development/README.md
    → Review coding-standards.md and patterns.md
    → Implement following protocol
    → Update plan if implementation reveals issues
```

**Why review each time:**

- Protocols contain nuanced guidance easily forgotten
- Each phase has specific checklists and requirements
- Earlier steps may reveal need to adjust later steps
- Fresh reading prevents autopilot mistakes

---

[rlm]: https://alexzhang13.github.io/blog/2025/rlm/
