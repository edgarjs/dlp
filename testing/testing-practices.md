# Testing Practices

Unit and integration testing practices for verifying individual components and their interactions.

---

## Unit Testing

Unit tests verify individual components in isolation. They form the foundation of the test pyramid, providing fast feedback on component correctness.

### What Makes a Good Unit Test

| Quality           | Description                                   |
| ----------------- | --------------------------------------------- |
| **Fast**          | Run in milliseconds, no I/O                   |
| **Isolated**      | No shared state, can run in parallel          |
| **Deterministic** | Same inputs, same outputs, no random failures |
| **Focused**       | One behavior per test                         |

### Arrange-Act-Assert Structure

```
test "calculates order total correctly":
  // Arrange: Set up the test data
  order = create_order()
  order.add_item(product_a, quantity=2, price=10.00)
  order.add_item(product_b, quantity=1, price=25.00)

  // Act: Perform the action being tested
  total = order.calculate_total()

  // Assert: Verify the expected outcome
  assert total == 45.00
```

- **Arrange** — Set up objects, configure mocks, prepare input data (keep minimal)
- **Act** — Perform the single action being tested (typically one line)
- **Assert** — Verify expected outcome (focused on what this test verifies)

---

## Test Doubles

Use test doubles when the real dependency is slow, non-deterministic, has side effects, or is hard to set up.

| Type     | Purpose                           | When to Use                                           |
| -------- | --------------------------------- | ----------------------------------------------------- |
| **Stub** | Returns predetermined values      | Need specific data, don't care about call count       |
| **Mock** | Verifies interactions occurred    | The interaction IS the behavior (e.g., notifications) |
| **Fake** | Working simplified implementation | Stubs too complex, need realistic behavior            |

### Usage Guidelines

- Prefer stubs over mocks — Verifying outputs is more robust than verifying calls.
- Keep fakes simple — Complex fakes become maintenance burdens.
- Mock at boundaries — Mock external systems, not internal collaborators.
- Avoid deep mocking — If mocking requires many levels, test at a different level.

---

## Edge Cases to Test

### Common Scenarios

| Category         | Examples                                                       |
| ---------------- | -------------------------------------------------------------- |
| Empty/Null       | Empty collections, null values, missing optional parameters    |
| Boundaries       | Min/max valid values, just below/above limits, zero, negatives |
| Special Values   | Very large/small values, special characters, unicode           |
| State Variations | First/last item, single vs. multiple, already in target state  |

---

## Integration Testing

Integration tests verify that components work together correctly. They catch issues at the boundaries between components.

### What Integration Tests Verify

- **Component interaction** — Components communicate correctly
- **Data flow** — Data passes correctly between components
- **Contract compliance** — Components honor their interfaces
- **Infrastructure integration** — Code works with real databases, APIs

### Unit vs. Integration Tests

| Aspect          | Unit Tests       | Integration Tests   |
| --------------- | ---------------- | ------------------- |
| Scope           | Single component | Multiple components |
| Speed           | Milliseconds     | Seconds             |
| Dependencies    | Mocked/stubbed   | Real or realistic   |
| What they catch | Logic errors     | Integration errors  |
| Quantity        | Many             | Fewer               |

---

## Real Dependencies vs. Test Doubles

**Use real dependencies when:**

- Testing the integration itself (that's the point)
- Testing database queries (need real database behavior)
- Test doubles would be complex to maintain

**Use test doubles when:**

- External service is unreliable, slow, or has side effects
- Setting up real service is impractical
- Need to test error scenarios hard to produce with real service

---

## Database Integration

| Approach         | Advantages                  | Disadvantages              |
| ---------------- | --------------------------- | -------------------------- |
| In-Memory DB     | Fast, no cleanup needed     | May differ from production |
| Test DB Instance | Same behavior as production | Slower, requires setup     |

### Database Testing Guidelines

- Setup: Create fresh schema or use transaction rollback
- Isolation: Tests should not depend on order; clean up after tests
- Speed: Minimize operations, use transactions for rollback

---

## API Integration

### Testing Your APIs

Test:

- Correct responses for valid requests
- Error responses for invalid requests
- Authentication and authorization
- Content types, headers, status codes

Approach:

- Use test client that makes real HTTP requests
- Test through HTTP layer, not by calling handlers directly

### Testing External APIs

| Approach         | Description                             |
| ---------------- | --------------------------------------- |
| Mock client      | Fast, controlled; may miss API changes  |
| Sandbox/test env | Real behavior; may be slow/rate-limited |
| Record/replay    | Balance of real behavior and speed      |

---

## Boundary Testing

Focus integration tests on component boundaries.

Testing boundary between OrderService and PaymentGateway:

```
test "order service handles payment timeout":
  // Arrange
  payment_gateway = create_slow_payment_gateway(timeout_after=30s)
  order_service = OrderService(payment_gateway)
  order = create_test_order()

  // Act
  result = order_service.process_payment(order)

  // Assert
  assert result.status == "payment_failed"
  assert result.error.type == "timeout"
  assert order.status == "pending"  // Not changed to paid
```

---

## Test Environment Management

### Environment Setup

Before tests:

- Start required services (database, message queue)
- Create schemas/tables
- Configure connections

After tests:

- Clean up test data
- Release connections
- Stop services (if started for tests)

### Test Data Management

- Each test creates what it needs
- Tests do not share mutable data
- Tests clean up after themselves
- Use transaction rollback for fast cleanup

---

## Checklist

### Unit Tests

- [ ] Test is fast (milliseconds)
- [ ] Test is isolated (no shared state)
- [ ] Test is deterministic (same result every time)
- [ ] Test is focused (one behavior)
- [ ] Arrange-Act-Assert structure is clear
- [ ] Happy path, edge cases, and error conditions tested

### Integration Tests

- [ ] Test environment is configured
- [ ] Dependencies are available (database, services)
- [ ] Tests focus on integration, not unit logic
- [ ] Tests verify component interactions
- [ ] Tests handle error scenarios
- [ ] Tests clean up after themselves
- [ ] Tests are reliable (no flakiness)

---

## Common Mistakes

| Mistake                | Poor                              | Better                                         |
| ---------------------- | --------------------------------- | ---------------------------------------------- |
| Testing Implementation | Verify internal calls             | Verify outputs, test public interface          |
| Too Much Setup         | 50 lines of setup                 | Minimal setup, use builders                    |
| Multiple Assertions    | Check 10 things                   | One test per scenario                          |
| Non-Deterministic      | Use current time                  | Inject time, control seeds                     |
| Slow Tests             | Network calls                     | Mock slow dependencies                         |
| Testing Too Much       | Integration tests that test logic | Test logic in unit tests                       |
| Flaky Tests            | Sometimes pass, sometimes fail    | See [test-maintenance.md](test-maintenance.md) |

---

## When Not to Unit Test

Some code may not need unit tests:

- **Trivial code** — Simple getters, basic delegation
- **Generated code** — Code produced by tools
- **Configuration** — Static configuration without logic
- **Thin wrappers** — Code that just calls another API

These are often better verified through integration tests, code review, or static analysis.
