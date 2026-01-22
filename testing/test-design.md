# Test Design

Test design covers how to write effective, maintainable tests. Well-designed tests provide confidence, aid debugging, and do not become a maintenance burden.

---

## Deriving Tests from Requirements

Tests should trace back to requirements.

### From Acceptance Criteria

Each acceptance criterion suggests tests:

```
Requirement: User login

Acceptance criteria:
  - User can log in with valid email and password
  - User sees error with invalid email
  - User sees error with incorrect password
  - Account locks after 5 failed attempts

Tests derived:
  test_login_with_valid_credentials_succeeds
  test_login_with_invalid_email_shows_error
  test_login_with_wrong_password_shows_error
  test_account_locks_after_five_failed_attempts
```

### From Edge Cases

Requirements specify normal behavior; tests must also cover edges. See [testing-practices.md](testing-practices.md) for a comprehensive list of edge case types (empty/null, boundaries, special values, state variations).

Derive edge cases from the requirement:

```
Requirement: Shopping cart total calculation
Edge cases: empty cart, single item, very large quantities, zero-price items
```

### Coverage Mapping

Track which requirements have tests:

```
| Requirement            | Test                     | Status  |
| ---------------------- | ------------------------ | ------- |
| Login with valid creds | test_login_succeeds      | Covered |
| Invalid email error    | test_invalid_email_error | Covered |
| Account lockout        | test_account_lockout     | Covered |
| Password reset         | (not implemented yet)    | Missing |
```

---

## Test Naming

Names should describe what the test verifies.

### Naming Principles

**Describe the scenario** — What conditions are being tested.

**State the expectation** — What should happen.

**Be specific** — Avoid generic names.

### Naming Examples

```
Poor names:
  test1
  test_login
  test_calculate

Better names:
  test_login_with_valid_credentials_returns_session_token
  test_login_with_expired_password_requires_reset
  test_calculate_total_with_discount_applies_percentage
```

### Naming Conventions

Choose a convention and apply it consistently:

```
Convention: given_when_then
  given_valid_credentials_when_login_then_succeeds

Convention: method_scenario_expectation
  login_validCredentials_returnsToken

Convention: should_behavior_when_condition
  should_return_token_when_credentials_valid
```

---

## Test Structure

Use consistent structure for readability. See [testing-practices.md](testing-practices.md) for detailed examples.

**Arrange-Act-Assert (AAA)** — Set up, perform action, verify outcome.

**Given-When-Then** — Alternative phrasing, same concept.

Guidelines:

- Clear separation between phases
- Minimal arrangement (only what this test needs)
- Single action per test
- Focused assertions on specific behavior

---

## Writing Good Assertions

Assertions verify expected outcomes.

### Assertion Guidelines

**Be specific** — Assert on exact values when possible.

```
Poor:  assert result is not null
Better: assert result.id == expected_id
        assert result.status == "active"
```

**Assert observable outcomes** — Verify what the code produces, not how.

```
Poor:  assert internal_counter == 5
Better: assert len(result.items) == 5
```

**One logical assertion per test** — Multiple asserts are fine if they verify one concept.

```
Fine (one concept):
  assert user.name == "Alice"
  assert user.email == "alice@example.com"
  assert user.is_active == true
  // All verify the created user is correct

Split (different concepts):
  test_user_creation_sets_correct_name
  test_user_creation_sends_welcome_email
```

### Assertion Messages

Include messages that help diagnose failures:

```
Poor:
  assert result == expected

Better:
  assert result == expected, "Expected order total {expected}, got {result}"
```

---

## Test Data

How you create test data affects test quality.

### Test Data Principles

**Minimal data** — Only create what the test needs.

```
Poor:
  Create complete user with all 20 fields filled in
  When test only checks email validation

Better:
  Create user with only email field set
```

**Obvious data** — Use values that make the test's purpose clear.

```
Poor:
  test_age_validation with age = 25  // Why 25?

Better:
  test_under_18_rejected with age = 17  // Clearly testing boundary
  test_18_and_over_accepted with age = 18
```

**Isolated data** — Each test creates its own data.

```
Poor:
  Global test user shared across tests
  Tests fail in certain orders

Better:
  Each test creates users it needs
  Tests are independent
```

### Test Data Patterns

**Builder pattern** — For complex objects.

```
user = UserBuilder()
  .with_email("test@example.com")
  .with_active_status()
  .build()
```

**Factory functions** — For common objects.

```
user = create_test_user(email="test@example.com")
order = create_test_order(user=user, items=3)
```

**Fixtures** — For shared read-only data.

```
Use fixtures for:
  - Reference data (countries, currencies)
  - Configuration
  - Complex objects needed by many tests

Avoid for:
  - Data that tests modify
  - Data that could cause test coupling
```

---

## Test Organization

Organize tests for findability and maintainability.

### File Organization

```
Option 1: Mirror source structure
  src/
    users/user_service.py
  tests/
    users/user_service_test.py

Option 2: Group by feature
  tests/
    user_registration/
      registration_test.py
      validation_test.py
    user_authentication/
      login_test.py
      password_reset_test.py
```

### Test Grouping

Group related tests:

```
UserServiceTests:
  test_create_user_with_valid_data
  test_create_user_with_duplicate_email_fails
  test_create_user_sends_welcome_email

  test_update_user_changes_name
  test_update_user_with_invalid_email_fails

  test_delete_user_removes_from_database
  test_delete_user_cancels_pending_orders
```

---

## Test Design Checklist

```
Coverage:
- [ ] Requirements map to tests
- [ ] Happy paths are tested
- [ ] Edge cases are tested
- [ ] Error conditions are tested

Quality:
- [ ] Tests are independent
- [ ] Tests are deterministic
- [ ] Test names describe scenarios
- [ ] Structure is consistent (AAA or Given-When-Then)

Maintainability:
- [ ] Tests do not depend on implementation details
- [ ] Test data is minimal and obvious
- [ ] Tests are organized logically
- [ ] Failed tests clearly indicate what broke
```

---

## Test Anti-Patterns

See also [testing-practices.md](testing-practices.md) for additional common testing mistakes.

| Anti-Pattern           | Problem                       | Fix                                                       |
| ---------------------- | ----------------------------- | --------------------------------------------------------- |
| Test-per-Method        | Tests methods, not behaviors  | Test individual behaviors: `test_calculate_with_discount` |
| Mystery Guest          | Relies on data from elsewhere | Create data explicitly in the test                        |
| Eager Test             | Verifies too many behaviors   | One behavior per test                                     |
| Implementation Testing | Breaks when refactored        | Test through public interface                             |
| Slow Tests             | Developers skip running them  | Mock slow dependencies                                    |
| Flaky Tests            | Intermittent pass/fail        | See [test-maintenance.md](test-maintenance.md)            |

---

## When Tests Are Hard to Write

Difficulty writing tests often indicates design problems:

- **Hard to construct object** — May have too many dependencies
- **Hard to verify outcome** — May have hidden side effects
- **Requires lots of mocking** — May have tight coupling
- **Test is complex** — Code under test may be too complex

Consider refactoring the code to improve testability.
