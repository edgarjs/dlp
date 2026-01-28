# Test Maintenance

Tests require ongoing maintenance. Well-maintained tests remain valuable; neglected tests become liabilities. This document covers keeping tests healthy over time.

---

## Why Tests Need Maintenance

Tests degrade for many reasons:

- **Code changes** — Implementation changes may require test updates
- **Requirement changes** — What was correct before is now wrong
- **Environment changes** — Dependencies, configurations, or platforms change
- **Test rot** — Tests become flaky, slow, or unclear over time

Neglected tests:

- Give false confidence (passing but not testing what matters)
- Slow down development (flaky failures, slow runs)
- Get ignored (nobody trusts them)

---

## When to Update Tests

### With Code Changes

**Behavior changed** — Tests must reflect new behavior.

- Old: calculate_tax returns flat 8%
- New: calculate_tax considers user location
- Action: Update tests to verify new location-based behavior

**Interface changed** — Tests must use new interface.

- Old: process(item) takes single item
- New: process(items) takes list
- Action: Update test calls, not necessarily test intent

**Refactoring** — Tests should not change.

- Refactoring changes how, not what.
- If tests need changes during refactoring, they tested implementation.
- This is an opportunity to improve test quality.

### With Requirement Changes

When requirements change, tests change:

```
Old requirement: Username must be 3-20 characters
New requirement: Username must be 3-30 characters
```

Action:

- Update boundary tests (20 → 30)
- Add tests for new valid range (21-30)
- Remove tests that verified old behavior

---

## When to Delete Tests

Not all tests should be kept forever.

### Delete Tests When

**The code they test is deleted** — Tests without code to test are waste.

**The requirement is removed** — Tests for obsolete features are confusing.

**The test is redundant** — Multiple tests verifying the same thing.

**The test provides no value** — Tests that always pass regardless of code changes.

### Do Not Delete Tests When

**The test is failing** — Fix or understand first; deleting hides problems.

**The test is inconvenient** — Inconvenient tests may be catching real issues.

**You do not understand what it tests** — Understand before deleting.

---

## Dealing with Flaky Tests

Flaky tests—tests that sometimes pass, sometimes fail—destroy trust in the test suite.

### Identifying Flaky Tests

Signs of flakiness:

- Test fails intermittently in CI
- Test passes locally but fails in CI (or vice versa)
- Test fails when run with other tests but passes alone
- Test results vary without code changes

### Common Causes

**Timing dependencies**

```
Problem: Test relies on operations completing in certain time
  assert process_completes_in_under(100ms)

Fix: Use conditions rather than timing
  wait_until(process_complete, timeout=10s)
  assert process_status == "complete"
```

**Shared state**

```
Problem: Tests share data that one test modifies
  Test A creates user "test@example.com"
  Test B expects no user with that email

Fix: Isolate test data
  Each test creates uniquely named data
  Each test cleans up after itself
```

**Non-deterministic behavior**

```
Problem: Test involves randomness or current time
  assert generated_id is unique  // Rare collision

Fix: Control non-determinism
  Seed random generators
  Inject time as dependency
```

**Resource contention**

```
Problem: Tests compete for limited resources
  Tests run in parallel, all use port 8080

Fix: Isolate resources
  Assign unique ports per test
  Use test-specific databases
```

### Fixing Flaky Tests

1. Reproduce reliably (run test many times, vary conditions)
2. Identify the cause (timing, state, resources, non-determinism)
3. Fix the root cause (do not just add retries)
4. Verify fix (run test many times after fix)
5. Monitor (watch for recurrence)

---

## Refactoring Tests

Tests should be refactored like production code.

### When to Refactor Tests

**Duplication** — Multiple tests with similar setup.

Before:

- Each test creates user, order, payment manually

After:

- Helper functions create test objects
- Tests use helpers, focus on behavior

**Unclear tests** — Tests that are hard to understand.

Before:

- `test_1()` with cryptic assertions

After:

- `test_user_with_expired_subscription_cannot_access_premium_content()`

**Slow tests** — Tests that take too long.

- Before: Each test starts fresh database
- After: Tests share database setup, use transactions for isolation

### Refactoring Guidelines

- **Keep tests passing** — Refactor in small steps
- **Maintain coverage** — Do not lose test coverage while refactoring
- **Improve clarity** — Refactoring should make tests easier to understand
- **Run frequently** — Verify tests still pass after each change

---

## Test Health Metrics

Monitor test suite health:

### Speed

- Metric: Total test suite run time
- Target: Fast enough that developers run tests frequently

Warning signs:

- Developers skip running tests
- CI takes too long
- Tests get slower over time

Actions:

- Profile slow tests
- Move slow tests to appropriate level
- Parallelize test execution
- Optimize setup/teardown

### Reliability

- Metric: Flaky test rate (failures without code changes)
- Target: Zero flaky tests

Warning signs:

- Tests are ignored because "they always fail"
- CI needs multiple retries
- Different results locally vs. CI

Actions:

- Track and prioritize flaky tests
- Fix or quarantine until fixed
- Do not merge with known flaky tests

### Coverage

- Metric: Code coverage percentage
- Target: Appropriate for risk level (see test-strategy.md)

Warning signs:

- Coverage dropping over time
- Critical paths uncovered
- Coverage theater (high numbers, weak tests)

Actions:

- Review coverage in code review
- Add tests for new code
- Focus on meaningful coverage, not numbers

### Maintenance Burden

- Metric: Time spent on test maintenance
- Target: Sustainable; not overwhelming development time

Warning signs:

- Tests break frequently with code changes
- Significant time fixing tests vs. writing features
- Developers dread test changes

Actions:

- Improve test design
- Test behavior, not implementation
- Reduce test brittleness

---

## Test Health Checklist

### Regular Review

- [ ] All tests pass consistently
- [ ] No known flaky tests (or they are being addressed)
- [ ] Test suite runs in acceptable time
- [ ] Coverage is at target levels
- [ ] Tests are understandable

### When Modifying Tests

- [ ] Test still verifies intended behavior
- [ ] Test name reflects current behavior
- [ ] Test data is minimal and obvious
- [ ] Test is not flaky

### Periodic Health Check

- [ ] Remove tests for deleted code
- [ ] Update tests for changed requirements
- [ ] Investigate and fix flaky tests
- [ ] Review and improve slow tests
- [ ] Check coverage against targets

---

## Test Suite Maintenance Schedule

**With every change:**

- Run relevant tests
- Update tests if behavior changed
- Ensure new code has tests

**Weekly:**

- Review test failures
- Address flaky tests
- Monitor test run times

**Monthly:**

- Review overall test health
- Clean up obsolete tests
- Assess coverage against targets

**Quarterly:**

- Comprehensive test suite review
- Refactor problematic areas
- Update test strategy if needed

---

## Signs of Test Suite Problems

| Symptom               | Possible Cause         | Action                 |
| --------------------- | ---------------------- | ---------------------- |
| Tests ignored         | Flaky or slow tests    | Fix reliability, speed |
| Tests always pass     | Weak assertions        | Strengthen tests       |
| Tests always fail     | Broken tests, not code | Fix or delete tests    |
| Afraid to change code | Brittle tests          | Improve test design    |
| Bugs in production    | Missing tests          | Improve coverage       |
| Slow development      | Too many tests         | Right-size test suite  |
