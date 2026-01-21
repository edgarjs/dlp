# Code Review

Code review is a collaborative process where developers examine each other's code. Reviews catch bugs, improve code quality, and spread knowledge across the team.

---

## Why Review Code

Code review provides multiple benefits:

**Quality** — A second pair of eyes catches bugs, oversights, and improvements.

**Knowledge sharing** — Reviewers learn about changes; authors learn from feedback.

**Consistency** — Reviews help maintain coding standards across the codebase.

**Collective ownership** — The team, not individuals, owns the code.

---

## Review Mindset

### For Reviewers

Approach reviews constructively:

- **Assume good intent** — The author is trying to solve a problem; help them do it better
- **Be specific** — Vague criticism is not actionable
- **Explain reasoning** — Why is a change better, not just what to change
- **Distinguish severity** — Critical issues vs. suggestions vs. nitpicks
- **Acknowledge good work** — Point out what works well, not just problems

### For Authors

Receive feedback productively:

- **Detach from ego** — The review is about the code, not you
- **Assume good intent** — Reviewers are trying to help
- **Ask questions** — If feedback is unclear, ask for clarification
- **Explain context** — Reviewers may lack context you have
- **Accept gracefully** — Not every suggestion must be implemented, but consider each

---

## What to Review

### Correctness

Does the code do what it should?

```
Checklist: Correctness
- [ ] Code implements the requirements
- [ ] Logic handles all specified cases
- [ ] Edge cases are addressed
- [ ] Error conditions are handled
- [ ] No obvious bugs
```

### Design

Is the code well-structured?

```
Checklist: Design
- [ ] Code follows the design
- [ ] Responsibilities are appropriately divided
- [ ] Dependencies are reasonable
- [ ] Abstractions are at the right level
- [ ] No unnecessary complexity
```

### Readability

Can others understand the code?

```
Checklist: Readability
- [ ] Names are clear and descriptive
- [ ] Code is not unnecessarily clever
- [ ] Logic flow is easy to follow
- [ ] Comments explain why (not what)
- [ ] Formatting is consistent
```

### Maintainability

Will the code be easy to change?

```
Checklist: Maintainability
- [ ] Changes are isolated (good encapsulation)
- [ ] No hidden dependencies or side effects
- [ ] Tests exist and are meaningful
- [ ] No duplicate code without reason
- [ ] Follows project conventions
```

### Security

Is the code safe?

```
Checklist: Security
- [ ] Input is validated
- [ ] No injection vulnerabilities
- [ ] Sensitive data is protected
- [ ] Authentication/authorization is correct
- [ ] No secrets in code
```

### Performance

Is the code efficient enough?

```
Checklist: Performance
- [ ] No obvious performance problems
- [ ] Algorithms are appropriate for data sizes
- [ ] Resources are released properly
- [ ] No unnecessary work in hot paths
```

---

## Giving Feedback

### Feedback Format

Structure feedback clearly:

```
[Severity] [Location] [Issue] [Suggestion]

Examples:

[Critical] OrderService.java:45
  Null check missing. If order is null, this will throw NullPointerException.
  Suggestion: Add guard clause at method start.

[Suggestion] UserController.java:120
  This loop could be simplified using a filter.
  Optional: Consider user_list.filter(u -> u.is_active())

[Nitpick] README.md:15
  Typo: "recieve" should be "receive"
```

### Feedback Severity

Categorize feedback by importance:

**Critical/Blocker** — Must be fixed before merging.
- Bugs that will cause failures
- Security vulnerabilities
- Violations of critical requirements

**Major** — Should be fixed but author can decide.
- Significant code quality issues
- Design concerns
- Missing error handling

**Minor/Suggestion** — Nice to fix but optional.
- Style improvements
- Alternative approaches
- Minor optimizations

**Nitpick** — Trivial issues.
- Typos
- Formatting inconsistencies
- Personal preferences

Mark severity clearly so authors can prioritize.

### Asking Questions

Sometimes the best feedback is a question:

```
"What happens if this list is empty?"
"Is this intentionally duplicated from UserService?"
"Could you explain why we need this timeout?"

Questions invite explanation rather than demanding changes.
They may reveal context the reviewer lacks.
```

---

## Receiving Feedback

### Processing Feedback

When you receive review feedback:

1. **Read all feedback first** — Get the full picture before responding
2. **Categorize by severity** — Address critical issues first
3. **Ask for clarification** — If something is unclear, ask
4. **Respond to each item** — Acknowledge, implement, or discuss
5. **Update code** — Make necessary changes
6. **Re-request review** — When changes are complete

### Responding to Feedback

```
Agree and fix:
  "Good catch, fixed."
  "Done, added null check."

Disagree with reason:
  "I considered that, but X because Y. Happy to discuss."
  "This is intentional because [reason]. Should I add a comment?"

Need clarification:
  "Could you elaborate on this concern?"
  "I'm not sure I understand. Do you mean X or Y?"

Defer:
  "Agreed this is an issue. Created ticket ABC-123 to address separately."
```

### When to Push Back

Not all feedback must be implemented. Push back when:

- The suggestion contradicts requirements
- You have context the reviewer lacks
- The change is out of scope
- You disagree on a subjective matter

Push back respectfully with reasoning, not defensively.

---

## Review Process

### Preparing for Review

Before requesting review:

```
- [ ] Code is complete (no TODO or WIP)
- [ ] Tests pass
- [ ] Self-review completed
- [ ] Commit history is clean
- [ ] Description explains the change
- [ ] Relevant context is provided
```

### Self-Review

Review your own code first:

1. Read through the diff as if seeing it for the first time
2. Check against the review checklists
3. Fix obvious issues before involving others
4. Note areas you are uncertain about

### Requesting Review

When requesting review, provide context:

```
What this change does:
  [Brief description]

Why this change is needed:
  [Link to requirement or explanation]

Areas to focus on:
  [Specific concerns or questions]

Testing done:
  [How you verified it works]
```

### Conducting Review

When reviewing:

1. Understand the goal before reading code
2. Start with the overview (architecture, design)
3. Move to details (implementation, edge cases)
4. Note issues as you find them
5. Summarize overall assessment

### Completing Review

End reviews with a clear status:

- **Approve** — Code is ready to merge
- **Request changes** — Critical issues must be addressed
- **Comment** — Feedback provided, no blocking issues

---

## Review Checklist

### For Reviewers

```
Preparation:
- [ ] Understand the goal of the change
- [ ] Have context on requirements

During review:
- [ ] Check correctness
- [ ] Check design
- [ ] Check readability
- [ ] Check maintainability
- [ ] Check security
- [ ] Check tests

Feedback:
- [ ] Categorize by severity
- [ ] Be specific and actionable
- [ ] Explain reasoning
- [ ] Ask questions when unclear
```

### For Authors

```
Before requesting:
- [ ] Self-review completed
- [ ] Tests pass
- [ ] Context provided

During review:
- [ ] Respond to all feedback
- [ ] Ask for clarification when needed
- [ ] Implement or discuss each item

After review:
- [ ] All critical issues addressed
- [ ] Re-request review after changes
```

---

## Common Review Issues

### Issues Reviewers Miss

- Security vulnerabilities (easy to overlook)
- Race conditions (hard to spot in static code)
- Missing error handling (focus on happy path)
- Test quality (focus on code, not tests)
- Documentation (forgotten if not obvious)

### Issues Authors Miss

- Edge cases in their own code
- Assumptions that are not obvious
- Impact on other parts of the system
- Alternative approaches

### Review Smells

Signs of problematic review:

- Rubber-stamping (approving without reading)
- Adversarial tone (attacking rather than helping)
- Scope creep (demanding unrelated changes)
- Bikeshedding (focusing on trivial matters)
- Drive-by comments (feedback without context)
