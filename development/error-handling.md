# Error Handling

Error handling determines how software responds when things go wrong. Good error handling makes systems robust, debuggable, and user-friendly.

---

## Error Categories

Different errors require different handling strategies.

### Recoverable vs. Unrecoverable

**Recoverable errors** — The operation failed but the system can continue.

```
Examples:
  - Invalid user input
  - Network timeout (can retry)
  - File not found (can prompt user)
  - Insufficient permissions
```

**Unrecoverable errors** — The system cannot continue safely.

```
Examples:
  - Out of memory
  - Corrupted critical data
  - Missing essential configuration
  - Programming errors (bugs)
```

### Expected vs. Unexpected

**Expected errors** — Known failure modes that are part of normal operation.

```
Examples:
  - User enters invalid email format
  - Payment is declined
  - Resource is temporarily unavailable
```

**Unexpected errors** — Failures that should not happen under normal circumstances.

```
Examples:
  - Null pointer where null should not be possible
  - Invalid state that invariants should prevent
  - Third-party library throws undocumented exception
```

---

## Handling Strategies

### Fail Fast

Detect errors as early as possible and stop processing immediately.

```
Fail fast example:
  process_order(order):
    if order is null:
      raise Error("Order cannot be null")
    if order.items is empty:
      raise Error("Order must have items")
    // Now we know order is valid
```

**When to use:** For precondition violations and programming errors.

**Benefit:** Errors are caught near their source, making debugging easier.

### Graceful Degradation

Continue operating with reduced functionality rather than failing completely.

```
Graceful degradation example:
  get_user_profile(user_id):
    profile = fetch_basic_profile(user_id)  // Required

    try:
      profile.recommendations = fetch_recommendations(user_id)
    catch NetworkError:
      profile.recommendations = []  // Continue without recommendations

    return profile
```

**When to use:** For non-critical features where partial results are better than no results.

**Benefit:** System remains useful even when some parts fail.

### Retry with Backoff

For transient failures, retry the operation with increasing delays.

```
Retry example:
  fetch_with_retry(url, max_attempts=3):
    for attempt in 1 to max_attempts:
      try:
        return fetch(url)
      catch TransientError:
        if attempt == max_attempts:
          raise
        wait(exponential_backoff(attempt))
```

**When to use:** For network requests and transient infrastructure failures.

**Considerations:** Set limits on retries; use exponential backoff; consider idempotency.

### Fallback Values

Provide default values when the preferred source fails.

```
Fallback example:
  get_configuration(key):
    try:
      return config_service.get(key)
    catch ServiceUnavailable:
      return default_values[key]  // Fallback to bundled defaults
```

**When to use:** When a sensible default exists and is better than failure.

**Risk:** Silently using fallbacks can mask problems. Log when fallbacks are used.

---

## Error Propagation

When a component encounters an error, it must decide: handle it or propagate it.

### When to Handle

Handle errors when:
- You can meaningfully recover
- You have context to handle it appropriately
- Propagating would lose important information
- The error is expected at this level

### When to Propagate

Propagate errors when:
- You cannot meaningfully recover
- A higher level has better context to handle it
- The error indicates a problem beyond your scope

### Error Transformation

When propagating, consider transforming the error:

```
Lower level throws: DatabaseConnectionError
Higher level catches and transforms:
  "Cannot process order: database unavailable"

Why transform:
  - Hide implementation details (user does not care about database)
  - Add context (what operation failed)
  - Convert to appropriate abstraction level
```

Preserve the original error as a cause for debugging:

```
catch DatabaseConnectionError as e:
  raise OrderProcessingError("Cannot process order", cause=e)
```

---

## User-Facing vs. Internal Errors

Errors shown to users differ from errors logged for developers.

### User-Facing Errors

User error messages should be:

**Helpful** — Tell users what went wrong and what to do about it.

```
Poor:  "Error 500"
Better: "We could not process your payment. Please check your card details and try again."
```

**Non-technical** — Avoid jargon, stack traces, or implementation details.

```
Poor:  "NullPointerException in OrderService.java:142"
Better: "Something went wrong. Please try again or contact support."
```

**Secure** — Do not reveal information that could help attackers.

```
Poor:  "Invalid password for user admin@example.com"
Better: "Invalid email or password"  // Does not confirm user exists
```

### Internal Errors

Internal error information should be:

**Detailed** — Include everything needed to diagnose the problem.

```
Log: ERROR 2024-01-15 10:23:45 OrderService.process
     Order processing failed for order_id=12345, user_id=67890
     Cause: PaymentGatewayTimeout after 30000ms
     Request ID: abc-123-def
     Stack trace: ...
```

**Contextual** — Include relevant state and identifiers.

**Structured** — Use consistent format for automated analysis.

---

## Error Reporting

### Logging

Log errors with sufficient context:

```
Logging checklist:
- [ ] Timestamp
- [ ] Severity level (error, warning, etc.)
- [ ] Error type/code
- [ ] Human-readable message
- [ ] Relevant identifiers (user_id, order_id, request_id)
- [ ] Stack trace (for unexpected errors)
- [ ] Context that led to the error
```

### Log Levels

Use appropriate severity:

- **Error** — Something failed; requires attention
- **Warning** — Something concerning but not a failure
- **Info** — Normal operation worth noting
- **Debug** — Detailed information for troubleshooting

### What Not to Log

- Sensitive data (passwords, tokens, personal information)
- High-volume repetitive errors (aggregate instead)
- Expected failures in normal operation (or log at debug level)

---

## Error Design

### Error Types

Define clear error types for different failure categories:

```
Application errors:
  ValidationError — Input failed validation
  NotFoundError — Requested resource does not exist
  ConflictError — Operation conflicts with current state
  AuthenticationError — User not authenticated
  AuthorizationError — User not authorized

Infrastructure errors:
  NetworkError — Network communication failed
  TimeoutError — Operation exceeded time limit
  ServiceUnavailableError — Dependency is down
```

### Error Information

Errors should carry useful information:

```
Error structure:
  type: Category of error
  message: Human-readable description
  code: Machine-readable identifier (optional)
  details: Additional structured information
  cause: Underlying error (if wrapping)
```

---

## Error Handling Checklist

```
- [ ] Errors are categorized (recoverable/unrecoverable, expected/unexpected)
- [ ] Appropriate strategy is used for each category
- [ ] Errors are handled at the right level
- [ ] Error propagation preserves useful context
- [ ] User-facing errors are helpful and secure
- [ ] Internal errors are detailed and logged
- [ ] Error types are clearly defined
- [ ] Sensitive information is not exposed
```

---

## Common Error Handling Mistakes

**Swallowing errors** — Catching and ignoring errors silently.

```
Poor:
  try:
    process()
  catch:
    pass  // Error disappears

Better:
  try:
    process()
  catch as e:
    log.error("Processing failed", e)
    // Then decide: retry, propagate, or degrade
```

**Generic catches** — Catching all errors when you can only handle specific ones.

```
Poor:
  try:
    process()
  catch Exception:  // Catches everything
    return default_value

Better:
  try:
    process()
  catch NetworkTimeout:
    return cached_value
  // Other exceptions propagate
```

**Error codes in returns** — Using special return values instead of proper error mechanisms.

```
Poor:
  user = get_user(id)  // Returns null or -1 for "not found"
  if user == null: ...

Better:
  user = get_user(id)  // Raises NotFoundError
  // Or returns explicit result type: Result<User, Error>
```

**Inconsistent handling** — Different parts of the codebase handle errors differently.

```
Problem:
  Module A returns null for not found
  Module B throws NotFoundError
  Module C returns {error: "not found"}

Solution: Establish conventions and follow them consistently
```
