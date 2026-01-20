# Document Format

This document explains how to read and execute the protocol. Understanding these conventions ensures you interpret guidance correctly and apply it effectively.

---

## Document Structure

Each document in this protocol follows a consistent structure:

1. **Title and overview** — What the document covers and why it matters
2. **Context** — Background information needed to understand the guidance
3. **Main content** — The actual guidance, using checklists, decision trees, and prose
4. **Cross-references** — Links to related documents when concepts connect

Not every document contains every element. Simple topics may skip context; reference documents may omit decision trees.

---

## Checklists

Checklists are ordered lists of items to address. They appear throughout the protocol to guide verification and completion.

### Reading Checklists

```
Checklist: Before committing code
1. [ ] Tests pass
2. [ ] No new warnings introduced
3. [ ] Commit message follows convention
4. [ ] Changes match the stated intent
```

Each item should be verified or completed. The order matters—items often build on previous items.

### Checklist Types

**Sequential checklists** — Items must be completed in order. Later items depend on earlier ones.

```
Checklist: Setting up a new module
1. [ ] Create directory structure
2. [ ] Define public interface
3. [ ] Implement core functionality
4. [ ] Add tests
```

**Verification checklists** — Items can be checked in any order. All must pass.

```
Checklist: Code review readiness
- [ ] Functionality matches requirements
- [ ] Error cases are handled
- [ ] Code is readable
- [ ] No obvious performance issues
```

**Conditional checklists** — Some items may not apply. Skip items that do not match your context.

```
Checklist: Pre-release verification
- [ ] All tests pass
- [ ] Documentation is updated
- [ ] If public API changed: migration guide exists
- [ ] If database schema changed: migration script tested
```

### Using Checklists

When executing a checklist:

1. Read the entire checklist first to understand scope
2. Address each item deliberately, not mechanically
3. If an item does not apply, note why and continue
4. If an item cannot be satisfied, stop and address the blocker
5. Completing a checklist should leave you confident the goal is achieved

---

## Decision Trees

Decision trees help select appropriate approaches based on context. They appear as Mermaid flowcharts.

### Reading Decision Trees

```mermaid
flowchart TD
    A[Start: Need to store data] --> B{Will data outlive process?}
    B -->|Yes| C{Need to query by multiple fields?}
    B -->|No| D[Use in-memory structure]
    C -->|Yes| E[Use database]
    C -->|No| F[Use file storage]
```

- **Rectangles** contain statements or starting points
- **Diamonds** contain questions to evaluate
- **Arrows** show paths based on answers

### Using Decision Trees

When navigating a decision tree:

1. Start at the entry point (usually top or left)
2. At each decision point, evaluate the question honestly
3. Follow the path that matches your answer
4. Reach a terminal node for the recommended approach
5. If no path fits, you may have an unusual case—see [decision-making.md](decision-making.md)

### Decision Tree Limitations

Decision trees simplify reality. They:

- Cannot capture every nuance
- Assume questions have clear answers
- May not cover edge cases

When a decision tree leads to an answer that feels wrong for your context, trust your judgment but document why you diverged.

---

## Templates

Templates provide structured formats for capturing information consistently.

### Reading Templates

Templates appear as blocks with placeholders:

```
Requirement: [short identifier]
Description: [what the system must do]
Rationale: [why this requirement exists]
Acceptance criteria:
  - [testable condition 1]
  - [testable condition 2]
Priority: [must-have | should-have | nice-to-have]
```

Placeholders in `[brackets]` indicate where you provide information. Text outside brackets is literal structure to preserve.

### Using Templates

When filling a template:

1. Read the entire template to understand its structure
2. Fill placeholders with specific, concrete information
3. Remove placeholder brackets in your final version
4. If a field does not apply, either omit it or mark it "N/A" with brief explanation
5. Add fields if the template lacks something important for your case

Templates are starting points, not constraints. Adapt them when necessary.

---

## Prose Sections

Not everything fits checklists or decision trees. Prose sections provide:

- **Context** — Background needed to understand guidance
- **Rationale** — Why certain approaches are recommended
- **Examples** — Concrete illustrations of abstract concepts
- **Warnings** — Common mistakes and how to avoid them

### Reading Prose

Prose in this protocol is intentionally concise. Every paragraph serves a purpose:

- If something seems obvious, it is included because people commonly overlook it
- If something seems detailed, the details matter for correct execution
- If cross-references appear, following them adds important context

---

## Pseudocode

Code examples in this protocol use language-agnostic pseudocode. The goal is clarity, not executability.

### Pseudocode Conventions

```
function process_order(order):
    if order.items is empty:
        halt Error("Cannot process empty order")

    total = 0
    for each item in order.items:
        total = total + item.price

    return total
```

- **Indentation** shows structure
- **Plain English** describes operations (`for each`, `if`, `halt`)
- **Dot notation** accesses properties (`order.items`)
- **No type annotations** unless types are the point being made

### Reading Pseudocode

Pseudocode demonstrates concepts, not implementation details. When reading:

1. Focus on the logic being illustrated
2. Translate to your language and conventions when implementing
3. Consider edge cases the pseudocode may omit for brevity
4. Do not copy pseudocode literally—adapt it to your context

---

## Cross-References

Documents reference each other when concepts connect.

### Reference Types

**Inline references** — Mentioned within flowing text: "See [principles.md](principles.md) for guidance on trade-offs."

**See also sections** — Listed at document end for related topics.

**Prerequisite references** — Indicate documents to read first: "This document assumes familiarity with [terminology.md](terminology.md)."

### Following References

Not every reference requires immediate action:

- Follow references when you need the linked context
- Skip references if you already understand the linked concept
- Return to references when you encounter confusion later

---

## Mandatory vs. Optional Content

Some guidance is prescriptive; some is advisory.

### Recognizing the Difference

**Mandatory language:**
- "Must," "shall," "required"
- Checklists with all items marked as necessary
- Decision trees with single paths for given conditions

**Advisory language:**
- "Should," "recommended," "prefer"
- "Consider," "may want to"
- Multiple acceptable options presented

### Deviating from Guidance

When deviating from recommendations:

1. Ensure you understand why the recommendation exists
2. Confirm your situation genuinely differs
3. Document your reasoning for future reference
4. Be prepared to revisit if the deviation causes problems

Deviating from mandatory guidance requires stronger justification and should be rare.
