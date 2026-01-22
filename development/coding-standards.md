# Coding Standards

Conventions for consistent, readable code. When everyone follows the same conventions, code becomes predictable.

---

## Naming Conventions

Good names make code self-explanatory.

### Naming Principles

**Be descriptive** — Names should reveal intent.

```
Poor:  d, tmp, data, x
Better: elapsed_days, temp_file, user_data, coordinate_x
```

**Be consistent** — Similar things should be named similarly.

```
Consistent:
  get_user(), get_order(), get_product()
  user_id, order_id, product_id

Inconsistent:
  get_user(), fetch_order(), retrieve_product()
  userId, order_id, ProductID
```

**Match scope to length** — Shorter names for smaller scopes; longer names for larger scopes.

```
Loop counter: i, j (small scope, well understood)
Module-level: user_authentication_service (large scope, needs clarity)
```

**Avoid abbreviations** — Unless universally understood.

```
Poor:  usr, auth, cfg, btn
Better: user, authentication, config, button
Exception: id, url, http (universally understood)
```

### Naming Patterns

**Variables** — Describe what they hold.

```
count (not c)
user_email (not ue or email1)
is_valid (boolean, reads as question)
```

**Functions** — Describe what they do.

```
calculate_total() (not calc())
send_notification() (not notify())
validate_input() (not check())
```

**Boolean variables/functions** — Frame as yes/no questions.

```
is_active, has_permission, can_edit
is_valid(), has_access(), should_retry()
```

**Classes/types** — Describe what they represent.

```
OrderService (not OS or OrSvc)
UserRepository (not UserRepo or UR)
```

---

## Code Organization

Organize code for readability and navigation.

### File Organization

**One concept per file** — Files should have a clear, single purpose.

```
Good:
  user_service.py — User business logic
  user_repository.py — User data access
  user_model.py — User data structure

Poor:
  user_stuff.py — Everything user-related mixed together
```

**Consistent file structure** — Files of the same type should have similar internal organization.

```
Standard file structure:
  1. Imports/dependencies
  2. Constants
  3. Type definitions
  4. Main implementation
  5. Helper functions
```

### Function Organization

**Single responsibility** — Each function does one thing.

```
Poor: process_order() that validates, saves, sends email, and logs

Better:
  validate_order()
  save_order()
  send_order_confirmation()
  log_order_created()

  process_order() orchestrates these
```

**Appropriate length** — Functions should be short enough to understand at a glance.

```
Guideline: If you cannot see the entire function on one screen,
consider breaking it down.

Exception: Some algorithms are inherently long. Do not artificially
split logic that belongs together.
```

**Parameters** — Limit the number of parameters.

```
Poor: create_user(name, email, phone, address, city, state, zip, country)

Better: create_user(user_data) where user_data is a structured object
```

---

## Comments

Comments explain what code cannot. Good code minimizes the need for comments; necessary comments are clear and useful.

### When to Comment

**Comment the why, not the what** — Code shows what happens; comments explain why.

```
Poor:
  i = i + 1  // increment i

Better:
  // Offset by 1 because the API uses 1-based indexing
  page_number = index + 1
```

**Comment non-obvious decisions** — When you chose an unusual approach, explain why.

```
// Using insertion sort here because the list is nearly sorted
// and small (< 50 items). Benchmarks showed 3x improvement over quicksort.
```

**Comment workarounds** — When working around bugs or limitations.

```
// WORKAROUND: Library X crashes on empty input.
// Remove this check when upgrading to version 2.0+
if input is not empty:
    process(input)
```

### When Not to Comment

**Do not comment obvious code** — If the code is clear, comments add noise.

```
// Get the user
user = get_user(id)  // This comment adds nothing

// Bad: Describing what the code does
// Loop through users and check if active
for user in users:
    if user.is_active:
        ...
```

**Do not leave commented-out code** — Delete unused code; version control preserves history.

```
Poor:
  // user.send_email()  // disabled for now
  // old_validation_logic()
  new_validation_logic()

Better:
  new_validation_logic()
  // Version control has the history if we need the old code
```

### Comment Quality

Good comments are:

- **Accurate** — They describe what the code actually does
- **Current** — They are updated when code changes
- **Necessary** — They add information not in the code
- **Clear** — They are written for readers, not the author

---

## Complexity Management

Complex code is hard to understand, test, and maintain. Manage complexity deliberately.

### Recognizing Complexity

Warning signs:

- Deeply nested conditionals (if inside if inside if)
- Functions longer than a screen
- Many parameters to a function
- Global state mutations
- Circular dependencies
- Code that requires extensive comments to understand

### Reducing Complexity

**Extract functions** — Break complex logic into named steps.

```
Before:
  if user and user.is_active and user.has_permission("edit"):
      if document.status == "draft":
          if document.owner_id == user.id or user.is_admin:
              ...

After:
  if can_edit_document(user, document):
      ...

  def can_edit_document(user, document):
      if not user_can_edit(user):
          return False
      if not document_is_editable(document):
          return False
      if not user_owns_or_is_admin(user, document):
          return False
      return True
```

**Reduce nesting** — Use early returns to flatten conditionals. See Guard Clause pattern in [patterns.md](patterns.md).

**Simplify conditionals** — Extract complex conditions to named variables or functions.

```
Before:
  if (user.age >= 18 and user.country == "US") or user.has_parental_consent:

After:
  is_adult_in_us = user.age >= 18 and user.country == "US"
  can_access = is_adult_in_us or user.has_parental_consent
  if can_access:
```

### Complexity Thresholds

Consider refactoring when:

- Function exceeds ~30-50 lines
- Nesting exceeds 3-4 levels
- Function has more than 4-5 parameters
- Cyclomatic complexity exceeds 10
- You need to scroll to see the entire function

These are guidelines, not rules. Use judgment.

---

## Consistency

Consistency trumps personal preference. A consistent codebase is easier to navigate than a codebase where each file follows different conventions.

### Maintaining Consistency

**Follow existing patterns** — When modifying existing code, match its style.

```
If the codebase uses:
  get_user_by_id(id)

Add:
  get_order_by_id(id)

Not:
  fetch_order(id)
```

**Use automated formatters** — Remove style debates by automating formatting.

**Update globally or not at all** — Do not leave mixed styles.

```
Poor:
  Some files use single quotes, some use double quotes

Better:
  Either all files use single quotes, or undertake project-wide migration
```

---

## Standards Checklist

```
- [ ] Naming conventions are defined and followed
- [ ] File organization is consistent
- [ ] Functions have single responsibilities
- [ ] Comments explain why, not what
- [ ] Complexity is managed
- [ ] Existing patterns are followed
- [ ] Automated tools enforce style where possible
```
