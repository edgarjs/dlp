# Design Review

Design review validates that the design is complete, consistent, and ready for implementation. This is the final checkpoint before committing significant development effort.

---

## Why Review Design

Design errors discovered during implementation are expensive. Review catches:

- Gaps where requirements are not addressed
- Inconsistencies between design elements
- Infeasible or high-risk approaches
- Unclear specifications that will cause implementation confusion
- Missing considerations (security, performance, operations)

---

## Review Scope

Design review covers all design artifacts:

- Architecture documentation
- Component specifications
- Data models
- API definitions
- Interface contracts
- Key decisions and their rationale

---

## Completeness Review

Verify that the design addresses all requirements.

### Mapping Table

Create explicit mapping:

| Requirement              | Design Element       | Notes            |
| ------------------------ | -------------------- | ---------------- |
| User can create orders   | OrderService.create  | Complete         |
| Order has status history | Order.status_history | Complete         |
| Orders notify on ship    | NotificationService  | Async via events |
| Response time < 500ms    | Caching layer        | Review load test |

---

## Consistency Review

Verify that design elements work together without contradiction.

### Data Flow Consistency

Trace data through the system:

**Data flow: Order creation**

1. API receives order request → validates format
2. OrderService.create → validates business rules
3. Creates Order entity → writes to OrderRepository
4. Publishes OrderCreated event → consumed by NotificationService
5. Returns created order → API formats response

Check at each step:

- Data format matches expectations
- Required fields are available
- Transformations are defined

---

## Feasibility Review

Verify that the design can actually be implemented.

### Risk Assessment

Identify and evaluate risks:

```
Risk: Payment gateway integration complexity
Likelihood: Medium
Impact: High (blocks order completion)
Mitigation: Spike to validate integration approach before full implementation

Risk: Performance under load
Likelihood: Low (similar systems perform well)
Impact: Medium
Mitigation: Include load testing in test plan
```

---

## Review Process

### Preparing for Review

Before review:

1. Ensure all design documents are complete
2. Verify documents are consistent with each other
3. Prepare requirements mapping
4. Note areas of uncertainty or concern
5. Identify reviewers

### Conducting the Review

During review:

1. Walk through design at appropriate level
2. Verify against checklists
3. Probe areas of concern
4. Document all issues found
5. Classify issues by severity

### Issue Classification

**Blocker** — Must be resolved before implementation can start.

- Example: `No design for required authentication system`
- Action: `Return to design to address gap`

**Major** — Should be resolved but work can start in unaffected areas.

```
Example: Inconsistent error handling approach
Action: Resolve before implementing affected components
```

**Minor** — Should be tracked but does not block progress.

```
Example: Naming could be clearer in one component
Action: Note for implementation, update docs
```

**Observation** — Worth noting but not requiring action.

```
Example: Alternative approach might be simpler
Action: Document for future reference
```

---

## Review Checklist

```
Completeness
- [ ] All requirements are addressed
- [ ] All components are specified
- [ ] All interfaces are defined
- [ ] Error handling is complete
- [ ] Non-functional requirements are addressed

Consistency
- [ ] No internal contradictions
- [ ] Interfaces align between components
- [ ] Data flows are coherent
- [ ] Naming is consistent

Feasibility
- [ ] Technical approach is viable
- [ ] Risks are identified and acceptable

Quality
- [ ] Design is appropriately simple
- [ ] Components are maintainable
- [ ] Design is testable

Process
- [ ] Review has occurred
- [ ] Issues are documented
- [ ] Blockers are resolved
- [ ] Approval is recorded
```

---

## Sign-Off

Design is approved when:

1. All completeness checks pass
2. No consistency issues remain
3. Feasibility is confirmed
4. Quality is acceptable
5. All blocker issues are resolved
6. Reviewers agree design is ready

### Documenting Approval

```
Design: Order Management System
Version: 1.0
Status: Approved for implementation
Date: 2024-01-20
Reviewers: [Names/roles]

Outstanding items:
- Minor: Update API documentation format (during implementation)

Conditions:
- Payment integration spike must complete before payment component

Notes:
- Load testing required before production deployment
```

---

## After Review

Once design is approved:

1. Use design documents as authoritative reference
2. Treat design changes as change control items
3. Begin development phase
4. Maintain design documents as implementation proceeds

**Design documents remain living artifacts—update them when implementation reveals needed changes, but track those changes deliberately.**
