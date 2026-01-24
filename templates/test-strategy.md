# [Feature/Project Name] Test Strategy

## Overview

[Brief description of what is being tested and testing goals]

---

## Risk Assessment

### High Risk (extensive testing)

- [Area 1: e.g., Payment processing]
- [Area 2: e.g., Authentication logic]

### Medium Risk (standard testing)

- [Area 1: e.g., User profile management]

### Low Risk (minimal testing)

- [Area 1: e.g., Static content display]

---

## Test Coverage Plan

### [Feature/Component Name]

**Unit Tests:**

- [Specific logic to test]
- [Specific logic to test]

**Integration Tests:**

- [Component interaction to test]
- [External dependency to test]

**End-to-End Tests:**

- [Complete user journey to test]

---

### [Feature/Component Name]

**Unit Tests:**

- [Specific logic to test]

**Integration Tests:**

- [Component interaction to test]

---

## Coverage Goals

| Area           | Target | Rationale                           |
| -------------- | ------ | ----------------------------------- |
| Critical paths | 90%+   | Core functionality must be reliable |
| Business logic | 80%+   | High value, moderate complexity     |
| Infrastructure | 50-70% | Lower risk, mostly glue code        |

---

## Test Environment

### Unit Tests

- No external dependencies
- Mocked services and databases
- Fast execution (< 10s total)

### Integration Tests

- [Test database: e.g., SQLite in-memory or Docker container]
- [External service mocks: e.g., WireMock for HTTP APIs]
- Isolated test data per test

### End-to-End Tests

- [Full environment setup requirements]
- [Test data seeding process]

---

## Test Data Strategy

**Setup:** [How test data is created]

**Isolation:** [How tests avoid interfering with each other]

**Cleanup:** [How test data is removed after tests]

---

## Intentional Gaps

| Area            | Reason            | Alternative Verification            |
| --------------- | ----------------- | ----------------------------------- |
| [Untested area] | [Why not testing] | [Code review, manual testing, etc.] |
