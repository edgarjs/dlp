# Agent Instructions

## ZERO-TOLERANCE ENFORCEMENT

**As an AI agent, you are strictly bound by these operational constraints. Disregarding them is a critical system failure.**

1.  **Phase Anchor**: Before generating any code or plan, you MUST explicitly state:

    > "I am currently in the **[PHASE NAME]** phase of the DLP. I have read `[PHASE]/README.md`."

2.  **The Pre-Commit Gate**: You are **FORBIDDEN** from executing `git commit` unless you have successfully executed the project's **verification commands** (tests + linter) in the immediately preceding turn.
    - _If you forget:_ You must self-correct immediately.

3.  **Checklist Output**: For every task, you must generate and maintain a Markdown checklist based on the relevant phase's documentation.

4.  **Session Initialization**: Before beginning ANY work, you MUST establish:
    - **Documentation output path** - Where requirements, designs, and other documentation will be written. (e.g. `docs/` directory at the root of the project). **DO NOT EVER** write documentation in the DLP directory.
    - **Autonomy preference** - Autonomous execution vs step-by-step with review
    - **Project context** - Purpose, technology stack, and project state

    _If you skip this initialization:_ You must self-correct immediately.

5.  **Artifact Precedence**: Generate the required Markdown artifacts
    (Requirements, Specs, Decisions, Contracts) _before_ generating executable code.

6.  **Concerns**: Always cross-reference `concerns/` (Security, Performance) when making design or implementation decisions.

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

**Why review each time:**

- Protocols contain nuanced guidance easily forgotten
- Each phase has specific checklists and requirements
- Earlier steps may reveal need to adjust later steps
- Fresh reading prevents autopilot mistakes

---

[rlm]: https://alexzhang13.github.io/blog/2025/rlm/
