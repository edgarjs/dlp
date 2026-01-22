# Agent Instructions: Recursive Loading Strategy

This protocol contains extensive documentation across multiple directories. To avoid context overload, use a [Recursive Language Model (RLM)][rlm] approach: load context selectively based on task relevance rather than ingesting entire directories.

## Loading Strategy

1. **Understand the protocol** - Always load `README.md` before accessing other protocol files. This will guide you on how to use the protocol.

2. **Search Before Loading** - Use (rip)grep to identify relevant files based on the user's task keywords (e.g., "API", "testing", "security", "requirements"). Load only matched files.

3. **Load Selectively** - Never load entire directories blindly. Read specific files identified through search or explicit phase needs.

4. **Decompose Complex Tasks** - When a task spans multiple protocol files, process each file in separate focused calls rather than loading everything at once.

5. **Follow Phase Progression** - When uncertain which files to load, respect the natural order: requirements → design → development → testing. Consult the appropriate phase directory's README.md for guidance.

## Agent Operational Summary

Strictly adhere to these operational primitives:

1.  **Phase Locking**: Identify the user's current intent and map it to a specific directory (Phase). Do not skip phases (e.g., do not write code without a design contract).
2.  **Checklist Enforcement**: Every phase has a `README.md` or specific file with a **Checklist**. You must satisfy these items before declaring a task complete.
3.  **Artifact Precedence**: Generate the required Markdown artifacts (Specifications, Decisions, Contracts) _before_ generating executable code.
4.  **Concerns**: Always cross-reference `concerns/` (Security, Performance) when making design or implementation decisions.

---

[rlm]: https://alexzhang13.github.io/blog/2025/rlm/
