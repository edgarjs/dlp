# Terminology

This glossary defines terms as they are used throughout this protocol. When a term appears in other documents, it carries the meaning specified here.

---

## General Concepts

### Requirement
A statement describing what the software must do or a quality it must have. Requirements describe the "what," not the "how."

### Specification
A formalized, detailed description of requirements that is precise enough to implement and test against. A specification removes ambiguity from requirements.

### Acceptance Criteria
Conditions that must be satisfied for a requirement to be considered complete. Acceptance criteria are testable statements that define "done."

### Stakeholder
Any person or system with an interest in the software being built. Stakeholders include users, clients, operators, and dependent systems.

### Scope
The boundaries of what will and will not be addressed. Scope defines what is included in the current effort and, equally important, what is explicitly excluded.

---

## Design Concepts

### Architecture
The high-level structure of a system: its components, their responsibilities, and how they interact. Architecture decisions are those that are costly to change later.

### Component
A distinct, encapsulated unit of functionality within a system. Components have defined interfaces and can be developed, tested, and reasoned about independently.

### Interface
The contract between a component and its consumers. An interface specifies what inputs a component accepts, what outputs it produces, and what guarantees it makes.

### Contract
A formal agreement between components specifying preconditions (what must be true before), postconditions (what will be true after), and invariants (what is always true).

### Dependency
A relationship where one component relies on another. Dependencies create coupling—changes to one component may require changes to its dependents.

### Coupling
The degree to which components depend on each other's internal details. Loose coupling means components interact through stable interfaces; tight coupling means they rely on internal implementation.

### Cohesion
The degree to which elements within a component belong together. High cohesion means a component does one thing well; low cohesion means it handles unrelated responsibilities.

---

## Implementation Concepts

### Implementation
The concrete realization of a design in code. Implementation translates architectural decisions and interface contracts into working software.

### Refactoring
Changing code structure without changing its external behavior. Refactoring improves internal quality (readability, maintainability) while preserving functionality.

### Technical Debt
The implied cost of future rework caused by choosing expedient solutions over better approaches. Technical debt accumulates interest—the longer it remains, the more costly it becomes.

### Edge Case
An input or scenario at the boundary of expected behavior. Edge cases include empty inputs, maximum values, unusual combinations, and transitions between states.

### Happy Path
The default scenario where everything works as expected—valid inputs, available resources, no errors. The happy path is what you demonstrate first, but not where bugs hide.

### Invariant
A condition that must always be true at certain points in execution. Invariants define the consistent states a system can be in.

---

## Testing Concepts

### Unit Test
A test that verifies a single component in isolation from the rest of the system. Unit tests are fast, focused, and independent of external resources.

### Integration Test
A test that verifies multiple components working together. Integration tests check that interfaces between components function correctly.

### Test Double
A substitute for a real component used during testing. Types include:
- **Stub**: Returns predetermined responses
- **Mock**: Verifies that specific interactions occurred
- **Fake**: A working but simplified implementation

### Test Coverage
A measure of how much code is exercised by tests. Coverage indicates what has been tested, not how well—high coverage does not guarantee quality.

### Regression
A bug introduced by a change that breaks previously working functionality. Regression tests verify that existing behavior is preserved after changes.

---

## Process Concepts

### Phase
A stage in the development process with distinct inputs and outputs. This protocol defines four phases: requirements, design, development, and testing.

### Iteration
A cycle of work that produces a potentially usable increment. Iterations allow for feedback and course correction during development.

### Verification
Confirming that the software was built correctly—does the implementation match the specification?

### Validation
Confirming that the right software was built—does the specification address the actual need?

### Trade-off
A situation where improving one quality requires sacrificing another. Trade-offs are inherent in software development; the goal is to make them consciously.

---

## Document Concepts

### Checklist
An ordered list of items to verify or complete. In this protocol, checklists guide action—each item should be addressed before proceeding.

### Decision Tree
A branching structure that guides choices based on conditions. Decision trees in this protocol help select appropriate approaches based on context.

### Template
A structured format for capturing information. Templates ensure consistency and completeness when documenting decisions, requirements, or designs.

---

## Usage Notes

When reading the protocol:

- If a term seems familiar but is used in an unexpected way, return here to verify the intended meaning
- Terms in **bold** in other documents indicate they carry specific meaning defined in this glossary
- Some terms have broader meanings in general usage; the definitions here specify how they apply within this protocol
