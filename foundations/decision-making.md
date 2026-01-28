# Decision Making

A framework for making choices when principles conflict or situations are not explicitly covered.

---

## The Nature of Decisions

Most decisions are trade-offs. The goal is making a defensible choice given current information.

### Decision Characteristics

**Reversible vs. irreversible** — Some decisions are easy to change later (variable names, internal implementation details). Others are costly to reverse (public API design, database schema, core architectural patterns). Invest more deliberation in irreversible decisions.

**High-impact vs. low-impact** — Some decisions affect the entire system. Others affect a single function. Scope your decision-making effort to match impact.

**Time-sensitive vs. open-ended** — Some decisions block progress and need resolution. Others can be deferred until more information is available. Distinguish between them.

---

## The Decision Framework

When facing a decision, work through these steps:

### 1. Clarify What You Are Deciding

State the decision precisely. Vague framing leads to vague conclusions.

- Vague: "How should we handle errors?"
- Precise: "Should validation errors be returned as a list of all errors or should we fail on the first error encountered?"

### 2. Identify the Constraints

What factors limit your options?

- **Requirements** — What does the specification demand?
- **Existing decisions** — What has already been committed to?
- **Resources** — What time, expertise, or infrastructure is available?
- **Dependencies** — What do other components expect?

Constraints eliminate options and simplify the decision space.

### 3. Generate Options

List the viable approaches. For most decisions, two to three options suffice. If you have only one option, you do not have a decision—you have a path. If you have more than four options, you may be conflating multiple decisions.

### 4. Evaluate Trade-offs

For each option, identify:

- **Benefits** — What does this option provide?
- **Costs** — What does this option sacrifice?
- **Risks** — What could go wrong?
- **Unknowns** — What information is missing?

### 5. Decide

Choose the option that best satisfies your constraints while managing risks. If options are close, prefer:

- Simpler over complex (KISS)
- Reversible over irreversible
- Less work now over speculative future work (YAGNI)

### 6. Document

Record what you decided and why. Future developers (including yourself) will benefit from understanding the reasoning, not just the outcome.

---

## When Principles Conflict

Principles sometimes tension with each other. See [Applying Principles Together](principles.md#applying-principles-together) for common tensions and resolution strategies.

When principles conflict in your specific situation:

1. Identify which principles are in tension
2. Consider which matters more for this context
3. Apply the more relevant principle
4. Document your resolution

There is no universal ranking of principles. Context determines priority.

---

## When to Decide Autonomously vs. Ask for Input

Not every decision requires consultation. Knowing when to decide alone and when to seek input is itself a skill.

### Decide Autonomously When

- The decision is reversible with low effort
- You have clear requirements and constraints
- The decision is within established patterns
- Waiting for input would cause significant delay
- The impact is local to your current work

### Seek Input When

- The decision affects others' work or expectations
- Requirements are ambiguous or conflicting
- The decision is irreversible or costly to change
- You lack expertise in the relevant domain
- Previous similar decisions were contentious
- You have roughly equal options and no strong preference

### How to Ask for Input

When seeking input:

1. State the decision clearly
2. Present the options you have identified
3. Share your analysis of trade-offs
4. Indicate your tentative preference (if any)
5. Ask a specific question

Good:

```
"For error responses, I see two options: return all validation errors
at once, or fail on the first error. The first is better for forms,
the second is simpler to implement. I'm leaning toward returning all
errors since this is user-facing. Does that align with expectations?"
```

Poor:

```
"How should I handle errors?"
```

---

## Documenting Decisions

Decisions should be recorded so they can be understood later.

### What to Document

- **The decision** — What was chosen
- **The context** — What situation prompted the decision
- **The options** — What alternatives were considered
- **The rationale** — Why this option was selected
- **The trade-offs** — What was sacrificed

### Where to Document

- **Code comments** — For implementation-level decisions that future maintainers need
- **Commit messages** — For decisions tied to specific changes
- **Design documents** — For architectural decisions that affect multiple components
- **README files** — For decisions that affect how the project is used

### Documentation Depth

Match documentation depth to decision significance:

- **Trivial decisions** — No documentation needed
- **Local decisions** — Brief comment or commit message
- **Cross-cutting decisions** — Dedicated section in design documentation
- **Architectural decisions** — Formal decision record with full rationale

---

## Handling Uncertainty

Sometimes you must decide without complete information.

### Strategies for Uncertainty

**Defer if possible** — If the decision can wait until more information is available without blocking progress, defer it. Build in a way that keeps options open.

**Decide and adapt** — If you must decide now, make the best choice with current information. Plan to revisit when you learn more.

**Reduce risk** — If uncertain, prefer options that are easier to reverse or that fail more gracefully.

**Prototype** — If the uncertainty is about feasibility or approach, a small experiment may resolve it faster than analysis.

### Avoiding Analysis Paralysis

Spending time on a decision has diminishing returns. When you catch yourself cycling through the same considerations:

1. Set a deadline for the decision
2. Accept that you may need to adjust later
3. Choose and move forward
4. Document the uncertainty for future review

An imperfect decision made now is often better than a perfect decision made too late.

---

## Learning from Decisions

Decisions create feedback loops. After a decision has played out:

- **Did it work?** Confirm the expected benefits materialized
- **What surprised you?** Note unexpected consequences
- **Would you decide differently now?** Capture lessons for future decisions

This reflection improves future decision-making but does not require changing past decisions that are working adequately.
