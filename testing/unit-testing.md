# Unit Testing

Unit tests verify individual components in isolation. They form the foundation of the test pyramid, providing fast feedback on component correctness.

---

## What Makes a Good Unit Test

### Fast

Unit tests should run in milliseconds, not seconds.

```
Why speed matters:
  - Developers run tests frequently
  - Slow tests get run less often
  - Fast feedback catches bugs early

Achieving speed:
  - No network calls
  - No database access
  - No file system operations
  - No waiting or sleeping
```

### Isolated

Unit tests should not depend on other tests or external state.

```
Isolation means:
  - Tests can run in any order
  - Tests can run in parallel
  - One test's failure does not affect others
  - Each test sets up its own data

Achieving isolation:
  - No shared mutable state between tests
  - Each test creates what it needs
  - Each test cleans up after itself (if needed)
```

### Deterministic

Unit tests should produce the same result every time.

```
Determinism means:
  - Same inputs, same outputs
  - No random failures
  - No dependency on time, network, or environment

Achieving determinism:
  - Control all inputs, including time
  - Mock non-deterministic dependencies
  - Avoid tests that depend on timing
```

### Focused

Unit tests should test one thing.

```
Focused means:
  - One behavior per test
  - Clear what failed when a test fails
  - Simple to understand

Achieving focus:
  - Test single scenarios
  - Use descriptive names
  - Keep tests short
```

---

## Arrange-Act-Assert Structure

Structure tests consistently for readability.

### The Pattern

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

### Arrange

Set up everything needed for the test:
- Create objects
- Configure mocks
- Prepare input data

Keep arrangement minimal—only what this specific test needs.

### Act

Perform the single action being tested:
- Call the function
- Invoke the method
- Trigger the behavior

Typically one line. If more, you may be testing too much.

### Assert

Verify the expected outcome:
- Check return values
- Verify state changes
- Confirm mock interactions (sparingly)

Keep assertions focused on what this test is verifying.

---

## Handling Dependencies

Unit tests need to isolate the component under test from its dependencies.

### When to Use Test Doubles

Use test doubles when the real dependency:
- Is slow (database, network)
- Is non-deterministic (time, random)
- Has side effects (sending emails, charging cards)
- Is hard to set up
- Is not available

### Types of Test Doubles

**Stub** — Returns predetermined values.

```
Purpose: Provide indirect inputs to the code under test

stub_user_repository.get_user(123) returns User(id=123, name="Test")

Use when:
  - You need the dependency to return specific data
  - You do not care how many times it is called
```

**Mock** — Verifies interactions occurred.

```
Purpose: Verify the code under test calls dependencies correctly

mock_email_service.expect_call(send_email, to="user@example.com")
// ... run code ...
mock_email_service.verify()

Use when:
  - The interaction IS the behavior (e.g., sending notifications)
  - Use sparingly—verifying interactions couples tests to implementation
```

**Fake** — A working simplified implementation.

```
Purpose: Provide realistic behavior without production complexity

fake_database = InMemoryDatabase()
// Acts like a real database but runs in memory

Use when:
  - Stubs would be too complex
  - Need realistic behavior for multiple operations
  - Integration test behavior at unit test speed
```

### Dependency Guidelines

```
Prefer stubs over mocks — Verifying outputs is more robust than verifying calls.

Keep fakes simple — Complex fakes become maintenance burdens.

Mock at boundaries — Mock external systems, not internal collaborators.

Avoid deep mocking — If mocking requires many levels, test at a different level.
```

---

## Edge Cases to Test

Always consider these scenarios:

### Empty and Null

```
- Empty collections (empty list, empty string)
- Null/undefined values
- Missing optional parameters
```

### Boundaries

```
- Minimum valid value
- Maximum valid value
- Just below minimum
- Just above maximum
- Zero
- Negative values (if applicable)
```

### Special Values

```
- Very large values
- Very small values
- Special characters in strings
- Unicode and encoding issues
```

### State Variations

```
- First item (no previous state)
- Last item (no next state)
- Single item vs. multiple items
- Already in target state
```

---

## Test Naming

Test names should describe the scenario and expected outcome.

### Naming Patterns

```
Pattern: [method]_[scenario]_[expectedResult]
  calculate_total_with_discount_returns_reduced_price
  validate_email_with_invalid_format_returns_false

Pattern: [scenario]_[expectedResult]
  empty_cart_returns_zero_total
  expired_token_raises_authentication_error

Pattern: should [expected behavior] when [condition]
  should return zero when cart is empty
  should raise error when token is expired
```

### Naming Guidelines

- **Be specific** — "test1" tells nothing; "empty_list_returns_zero" is clear
- **Describe behavior** — What should happen, not how it is implemented
- **Include context** — What conditions lead to this outcome
- **Read naturally** — Names should be readable sentences

---

## Unit Test Checklist

### Test Quality

```
- [ ] Test is fast (milliseconds)
- [ ] Test is isolated (no shared state)
- [ ] Test is deterministic (same result every time)
- [ ] Test is focused (one behavior)
- [ ] Test name describes the scenario
- [ ] Arrange-Act-Assert structure is clear
```

### Coverage

```
- [ ] Happy path is tested
- [ ] Edge cases are tested
- [ ] Error conditions are tested
- [ ] Boundary values are tested
- [ ] Null/empty cases are tested
```

### Maintenance

```
- [ ] Test does not depend on implementation details
- [ ] Test will not break on refactoring
- [ ] Test failure message is clear
- [ ] Test is easy to understand
```

---

## Common Unit Testing Mistakes

### Testing Implementation

```
Poor:
  Verify internal method calls in specific order
  Assert on private state
  Test that specific lines of code execute

Better:
  Verify outputs and observable behavior
  Test through public interface
  Allow implementation to change freely
```

### Too Much Setup

```
Poor:
  50 lines of setup for a simple test
  Complex object graphs just to test one method

Better:
  Minimal setup for what this test needs
  Builder patterns or factories for complex objects
  If setup is complex, maybe testing at wrong level
```

### Multiple Assertions per Test

```
Poor:
  One test that checks 10 different things
  Failure could be any of the 10; hard to diagnose

Better:
  One test per scenario
  Clear which behavior failed
  Exception: Multiple assertions about one logical outcome is fine
```

### Non-Deterministic Tests

```
Poor:
  Tests that use current time
  Tests that depend on random values
  Tests that sometimes pass, sometimes fail

Better:
  Inject time as dependency
  Control random seeds
  Eliminate all non-determinism
```

### Slow Tests

```
Poor:
  Unit tests that take seconds each
  Tests that do network calls
  Tests that wait for timeouts

Better:
  Mock all slow dependencies
  Avoid any I/O in unit tests
  Keep tests under 100ms ideally
```

---

## When Not to Unit Test

Some code may not need unit tests:

- **Trivial code** — Simple getters, basic delegation
- **Generated code** — Code produced by tools
- **Configuration** — Static configuration that does not contain logic
- **Thin wrappers** — Code that just calls another API

Instead, these are often better verified through:
- Integration tests
- Code review
- Type checking
- Static analysis

Do not skip testing just because something is hard to test—but do evaluate whether the difficulty indicates a design problem.
